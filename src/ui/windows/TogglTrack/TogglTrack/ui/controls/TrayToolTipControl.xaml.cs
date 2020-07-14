using System.Windows;
using TogglTrack.ViewModels;

namespace TogglTrack
{
    public partial class TrayToolTipControl
    {
        public TrayToolTipControl()
        {
            InitializeComponent();
        }

        public TimeEntryLabelViewModel TimeEntryLabel
        {
            get => timeEntryLabel.ViewModel;
            set => timeEntryLabel.ViewModel = value;
        }

        public static readonly DependencyProperty TotalTodayProperty = DependencyProperty.Register(
            "TotalToday", typeof(string), typeof(TrayToolTipControl), new PropertyMetadata(default(string)));

        public string TotalToday
        {
            get { return (string) GetValue(TotalTodayProperty); }
            set { SetValue(TotalTodayProperty, value); }
        }

        public static readonly DependencyProperty IsTrackingProperty = DependencyProperty.Register(
            "IsTracking", typeof(bool), typeof(TrayToolTipControl), new PropertyMetadata(default(bool)));

        public bool IsTracking
        {
            get { return (bool) GetValue(IsTrackingProperty); }
            set { SetValue(IsTrackingProperty, value); }
        }

        public void SetDuration(string t)
        {
            durationLabel.Text = t;
        }

        public void SetDuration(Toggl.TogglTimeEntryView item)
        {
            durationLabel.Text =
                item.Ended > item.Started
                    ? item.Duration
                    : Toggl.FormatDurationInSecondsHHMMSS(item.DurationInSeconds);
        }
    }
}