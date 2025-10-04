using Godot;

public class Item : Resource
{
  [Export]
  public string itemName = "";
  [Export]
  public string itemDescription = "";
  [Export]
  public string itemImage = "res://item_images/default.png";
  [Export]
  public float itemCost = 0f;

  protected override void _Ready()
  {
	// Initialize image node
	Sprite spriteNode = GetNode<Sprite>("Sprite");
	spriteNode.Texture = GD.Load<Texture>(itemImage);

	// Initialize item node
	Item item = Sprite.GetItem(spriteNode);

	// Trade item logic here
	if (item.IsEquipped)
	{
	  // Trade item
	  item.TradeItem();
	}
  }

  public void TradeItem()
  {
	// Trade item logic here
	GD.Print($"Traded item: {itemName} for {itemCost}");
  }

  public void EquipItem()
  {
	// Toggle equipped status
	isEquipped = true;
  }

  public void ConsumeItem()
  {
	// Toggle consumed status
	isConsumed = true;
  }

  public Dictionary<string, object> GetItemData()
  {
	// Return item data as a dictionary
	return new Dictionary<string, object>()
	{
	  {"name", itemName},
	  {"description", itemDescription},
	  {"image", itemImage}
	};
  }
}
