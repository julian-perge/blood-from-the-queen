using System;
using System.Collections;
using System.Collections.Generic;
using Pixelplacement;
using UnityEngine;

namespace DiskCardGame
{
	public class Deck : ManagedBehaviour
	{
		private List<CardInfo> cards = new List<CardInfo>();

		private int randomSeed;

		public int CardsInDeck => cards.Count;

		public void Initialize(List<CardInfo> cardInfos, int randomSeed)
		{
			cards.AddRange(cardInfos);
			this.randomSeed = randomSeed;
		}

		public CardInfo Draw()
		{
			return Draw(null);
		}

		public CardInfo Draw(CardInfo specificCard)
		{
			CardInfo cardInfo = null;
			if (specificCard != null && cards.Contains(specificCard))
			{
				cardInfo = specificCard;
			}
			else
			{
				if (cards.Count == 0)
				{
					return null;
				}
				cardInfo = cards[SeededRandom.Range(0, cards.Count, randomSeed++)];
			}
			cards.Remove(cardInfo);
			return cardInfo;
		}

		public void ClearCards()
		{
			cards.Clear();
		}

		public void AddCard(CardInfo card)
		{
			cards.Add(card);
		}

		public IEnumerator Tutor()
		{
			CardInfo selectedCard = null;
			yield return Singleton<CardDrawPiles>.Instance.Deck.ChooseCard(delegate(CardInfo c)
			{
				selectedCard = c;
			});
			Singleton<ViewManager>.Instance.SwitchToView(View.Default);
			yield return Singleton<CardSpawner>.Instance.SpawnCardToHand(selectedCard);
		}

		public IEnumerator ChooseCard(Action<CardInfo> cardSelectedCallback)
		{
			Singleton<ViewManager>.Instance.SwitchToView(View.DeckSelection, immediate: false, lockAfter: true);
			SelectableCard selectedCard = null;
			yield return Singleton<BoardManager>.Instance.CardSelector.SelectCardFrom(cards, (Singleton<CardDrawPiles>.Instance as CardDrawPiles3D).Pile, delegate(SelectableCard x)
			{
				selectedCard = x;
			});
			Tween.Position(selectedCard.transform, selectedCard.transform.position + Vector3.back * 4f, 0.1f, 0f, Tween.EaseIn);
			UnityEngine.Object.Destroy(selectedCard.gameObject, 0.1f);
			cardSelectedCallback(selectedCard.Info);
		}

		public bool HasCard(CardInfo card)
		{
			return cards.Contains(card);
		}

		public CardInfo GetCardByName(string name)
		{
			return cards.Find((CardInfo x) => x.name == name);
		}

		public List<CardInfo> GetFairHand(int numCards, bool includeTier0Card = true, List<CardInfo> existingHand = null)
		{
			List<CardInfo> list = new List<CardInfo>(cards);
			List<CardInfo> hand = new List<CardInfo>();
			if (existingHand != null)
			{
				list.RemoveAll((CardInfo x) => existingHand.Contains(x));
				hand.AddRange(existingHand);
			}
			if (includeTier0Card)
			{
				List<CardInfo> list2 = list.FindAll((CardInfo x) => x.CostTier == 0 && !x.HasAbility(Ability.GemDependant));
				if (list2.Count > 0)
				{
					CardInfo item = list2[SeededRandom.Range(0, list2.Count, randomSeed++)];
					hand.Add(item);
					list.Remove(item);
				}
			}
			while (hand.Count < numCards - 1)
			{
				CardInfo item2 = list[SeededRandom.Range(0, list.Count, randomSeed++)];
				hand.Add(item2);
				list.Remove(item2);
			}
			if (!hand.Exists((CardInfo x) => CardCanBePlayedByTurn2WithHand(x, hand) && x.CostTier > 0 && !x.HasTrait(Trait.Pelt)))
			{
				List<CardInfo> list3 = list.FindAll((CardInfo x) => CardCanBePlayedByTurn2WithHand(x, hand) && x.CostTier > 0 && !x.HasTrait(Trait.Pelt));
				if (list3.Count > 0)
				{
					CardInfo item3 = list3[SeededRandom.Range(0, list3.Count, randomSeed++)];
					hand.Add(item3);
					list.Remove(item3);
				}
			}
			if (hand.Count < numCards && list.Count > 0)
			{
				CardInfo item4 = list[SeededRandom.Range(0, list.Count, randomSeed++)];
				hand.Add(item4);
				list.Remove(item4);
			}
			return hand;
		}

		private bool CardCanBePlayedByTurn2WithHand(CardInfo card, List<CardInfo> hand)
		{
			List<CardInfo> list = hand.FindAll((CardInfo x) => x.CostTier == 0 && x.Sacrificable);
			bool flag = card.BloodCost == 0 || card.BloodCost <= list.Count;
			bool flag2 = card.BonesCost == 0 || hand.FindAll((CardInfo x) => x.CostTier == 0 && x.HasAbility(Ability.Brittle)).Count <= card.BonesCost;
			bool flag3 = card.EnergyCost <= 2;
			bool flag4 = true;
			using (List<GemType>.Enumerator enumerator = card.GemsCost.GetEnumerator())
			{
				while (enumerator.MoveNext())
				{
					switch (enumerator.Current)
					{
					case GemType.Green:
						if (!hand.Exists((CardInfo x) => x.HasAbility(Ability.GainGemGreen)))
						{
							flag4 = false;
						}
						break;
					case GemType.Orange:
						if (!hand.Exists((CardInfo x) => x.HasAbility(Ability.GainGemOrange)))
						{
							flag4 = false;
						}
						break;
					case GemType.Blue:
						if (!hand.Exists((CardInfo x) => x.HasAbility(Ability.GainGemBlue)))
						{
							flag4 = false;
						}
						break;
					}
				}
			}
			return flag && flag2 && flag3 && flag4;
		}
	}
}
