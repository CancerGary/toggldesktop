namespace TogglTrack.AutoCompletion.Items
{
    public interface IAutoCompleteItem
    {
        string Text { get; }
        ItemType Type { get; }
    }
}