namespace DiskCardGame
{
	public class CardsInHand : VariableStatBehaviour
	{
		protected override SpecialStatIcon IconType => SpecialStatIcon.Bell;

		protected override int[] GetStatValues()
		{
			int count = Singleton<PlayerHand>.Instance.CardsInHand.Count;
			return new int[2] { count, 0 };
		}
	}
}
