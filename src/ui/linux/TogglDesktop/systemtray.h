// Copyright 2018 Toggl Desktop developers.

#ifndef SYSTEMTRAY_H
#define SYSTEMTRAY_H

#include <QSystemTrayIcon>
#include <QtDBus/QtDBus>

#include "timeentryview.h"

class MainWindowController;
class SettingsView;

class SystemTray : public QSystemTrayIcon
{
    Q_OBJECT
public:
    SystemTray(MainWindowController *parent = nullptr, QIcon defaultIcon = QIcon());

    MainWindowController *mainWindow();

    bool isVisible() const;
    bool notificationsAvailable();

protected slots:
    void notificationCapabilitiesReceived(QDBusPendingCallWatcher *watcher);
    uint requestNotification(uint previous, const QString &title, const QString &description);
    void notificationClosed(uint id, uint reason);
    void notificationActionInvoked(uint id, const QString &action);

    void displayIdleNotification(
        const QString guid,
        const QString since,
        const QString duration,
        const uint64_t started,
        const QString description);

    void displayReminder(QString title, QString description);

    void displayRunningTimerState(TimeEntryView *view);
    void displayStoppedState();

    void updateTooltip();


private:
    QTimer *idleHintTimer;
    QDBusInterface *notifications;

    uint lastIdleNotification { 0 };
    uint lastReminder { 0 };

    QString lastTimeEntryGuid;
    uint64_t lastStarted;

    bool notificationsPresent;

    TimeEntryView *runningTimeEntry { nullptr };
    QTimer updateTooltipTimer;
};

#endif // SYSTEMTRAY_H
