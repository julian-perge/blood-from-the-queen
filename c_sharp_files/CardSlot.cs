using UnityEngine;

namespace DiskCardGame
{
	public class CardSlot : HighlightedInteractable
	{
		[Header("Card Slot")]
		public CardSlot opposingSlot;

		[SerializeField]
		private GameObject conduitFrame;

		private bool choosable;

		public PlayableCard Card { get; set; }

		public bool WithinConduitCircuit { get; private set; }

		public int Index
		{
			get
			{
				if (IsPlayerSlot)
				{
					return Singleton<BoardManager>.Instance.PlayerSlotsCopy.IndexOf(this);
				}
				return Singleton<BoardManager>.Instance.OpponentSlotsCopy.IndexOf(this);
			}
		}

		public bool IsPlayerSlot => Singleton<BoardManager>.Instance.PlayerSlotsCopy.Contains(this);

		public bool Chooseable
		{
			get
			{
				return choosable;
			}
			set
			{
				choosable = value;
				if (Singleton<InteractionCursor>.Instance.CurrentInteractable == this)
				{
					OnCursorEnter();
				}
			}
		}

		public void SetWithinConduitCircuit(bool inCircuit)
		{
			WithinConduitCircuit = inCircuit;
			DisplayInConduitCircuit(inCircuit);
		}

		public void SetTexture(Texture t)
		{
			base.transform.Find("Quad").GetComponent<Renderer>().material.mainTexture = t;
		}

		protected virtual void DisplayInConduitCircuit(bool inCircuit)
		{
			if (conduitFrame != null)
			{
				conduitFrame.SetActive(inCircuit);
			}
		}

		protected virtual void OnCursorEnterWithCard()
		{
		}

		protected override void OnCursorSelectStart()
		{
			Singleton<BoardManager>.Instance.OnSlotSelected(this);
		}

		protected override void OnCursorEnter()
		{
			if (Card != null)
			{
				if (Singleton<BoardManager>.Instance.ChoosingSacrifices && Card.CanBeSacrificed)
				{
					Card.Anim.SetSacrificeHoverMarkerShown(shown: true);
				}
				OnCursorEnterWithCard();
			}
			else
			{
				PlaySound();
				if (Chooseable)
				{
					ShowState(State.Highlighted);
				}
				else
				{
					ShowState(State.Highlighted, immediate: true);
				}
			}
		}

		protected override void OnCursorExit()
		{
			if (Card != null)
			{
				Card.Anim.SetSacrificeHoverMarkerShown(shown: false);
			}
			ShowState(State.Interactable);
		}
	}
}
