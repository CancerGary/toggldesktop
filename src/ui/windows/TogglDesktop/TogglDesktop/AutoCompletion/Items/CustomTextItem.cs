namespace TogglDesktop.AutoCompletion.Items
{
    internal class CustomTextItem : AutoCompleteItem
    {
        public string Title { get; }
        public CustomTextItem(string title, string text)
            : base(text, ItemType.CUSTOM_TEXT)
        {
            Title = title;
        }
    }
}