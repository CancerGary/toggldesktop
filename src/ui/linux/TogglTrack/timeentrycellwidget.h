// Copyright 2014 Toggl Track developers.

#ifndef SRC_UI_LINUX_TOGGLTRACK_TIMEENTRYCELLWIDGET_H_
#define SRC_UI_LINUX_TOGGLTRACK_TIMEENTRYCELLWIDGET_H_

#include <QWidget>

#include "./timeentryview.h"
#include "./clickablelabel.h"

namespace Ui {
class TimeEntryCellWidget;
}

class QListWidgetItem;

class TimeEntryCellWidget : public QWidget {
    Q_OBJECT

 public:
    TimeEntryCellWidget(QListWidgetItem *item);
    ~TimeEntryCellWidget();

    void display(TimeEntryView *view);
    QSize getSizeHint(bool is_header);
    void labelClicked(QString field_name);
    void setLoadMore(bool load_more);

    QString entryGuid();
    void toggleGroup(bool open);

 public slots:
    void deleteTimeEntry();

 protected:
    virtual bool eventFilter(QObject *watched, QEvent *event) override;
    virtual void focusInEvent(QFocusEvent *event) override;
    virtual void resizeEvent(QResizeEvent *) override;

 private slots:  // NOLINT
    void on_continueButton_clicked();
    void on_groupButton_clicked();
    void on_loadMoreButton_clicked();
    void on_dataFrame_clicked();

 private:
    Ui::TimeEntryCellWidget *ui;
    QListWidgetItem *item;

    QString description;
    QString project;
    QString guid;
    bool group;
    bool groupOpen;
    QString groupName;
    TimeEntryView *timeEntry;
    QString getProjectColor(QString color);

    void setupGroupedMode(TimeEntryView *view);
    void setEllipsisTextToLabel(ClickableLabel *label, QString text);
};

#endif  // SRC_UI_LINUX_TOGGLTRACK_TIMEENTRYCELLWIDGET_H_
