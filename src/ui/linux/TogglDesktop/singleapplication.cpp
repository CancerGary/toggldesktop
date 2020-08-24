// Copyright 2015 Toggl Desktop developers.

#include "./singleapplication.h"

#include <QtNetwork/QLocalSocket>
#include <QFileInfo>

#include "toggl_api.h"

#define TIMEOUT_MS                (500)

SingleApplication::SingleApplication(int &argc, char **argv)
    : QApplication(argc, argv)
, w(nullptr)
, is_running_(false)
, local_server_(nullptr) {
    server_name_ = QFileInfo(
        QCoreApplication::applicationFilePath()).fileName();
    if (toggl_get_server_type() == TogglServerStaging)
        server_name_.append("-staging");

    initLocalConnection();
}

bool SingleApplication::isRunning() {
    return is_running_;
}

void SingleApplication::newLocalConnection() {
    QLocalSocket *socket = local_server_->nextPendingConnection();
    if (socket) {
        socket->waitForReadyRead(2 * TIMEOUT_MS);
        delete socket;

        activateWindow();
    }
}

void SingleApplication::initLocalConnection() {
    is_running_ = false;

    QLocalSocket socket;
    socket.connectToServer(server_name_);
    if (socket.waitForConnected(TIMEOUT_MS)) {
        fprintf(stderr, "%s already running.\n",
                server_name_.toLocal8Bit().constData());
        is_running_ = true;
        return;
    }

    newLocalServer();
}

void SingleApplication::newLocalServer() {
    local_server_ = new QLocalServer(this);
    connect(local_server_, SIGNAL(newConnection()),
            this, SLOT(newLocalConnection()));
    if (!local_server_->listen(server_name_)) {
        if (local_server_->serverError() ==
                QAbstractSocket::AddressInUseError) {
            QLocalServer::removeServer(server_name_);
            local_server_->listen(server_name_);
        }
    }
}

void SingleApplication::activateWindow() {
    if (w) {
        w->show();
        w->raise();
        w->activateWindow();
    }
}
