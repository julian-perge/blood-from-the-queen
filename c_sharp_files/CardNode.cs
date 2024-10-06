using XNode;

namespace DiskCardGame
{
	[NodeTint("#68B274")]
	public class CardNode : ConceptNode
	{
		public CardInfo card;

		public override bool IsSatisfied()
		{
			if (ProgressionData.LearnedCard(card))
			{
				return base.IsSatisfied();
			}
			return false;
		}
	}
}
