using System;
using System.Collections.Generic;
using UnityEngine;

namespace DiskCardGame
{
	public class DeckInfo : CardCollectionInfo
	{
		private List<BoonData> boons;

		[SerializeField]
		private List<BoonData.Type> boonIds;

		[SerializeField]
		private Dictionary<string, List<CardModificationInfo>> cardIdModInfos = new Dictionary<string, List<CardModificationInfo>>();

		private const string DUPLICATE_SUFFIX_SEPARATOR = "#";

		public List<BoonData> Boons
		{
			get
			{
				if (boons == null)
				{
					LoadBoons();
				}
				return boons;
			}
		}

		public bool HasBoonOfType(BoonData.Type boonType)
		{
			return Boons.Exists((BoonData x) => x.type == boonType);
		}

		public void AddBoon(BoonData.Type boonType)
		{
			Boons.Add(BoonsUtil.GetData(boonType));
			boonIds.Add(boonType);
		}

		public void ClearBoons()
		{
			if (boons == null)
			{
				LoadBoons();
			}
			boonIds.Clear();
			Boons.Clear();
		}

		public override CardInfo AddCard(CardInfo card)
		{
			List<CardModificationInfo> mods = card.Mods;
			CardInfo cardInfo = base.AddCard(card);
			UpdateModDictionary();
			foreach (CardModificationInfo item in mods)
			{
				ModifyCard(cardInfo, item);
			}
			return cardInfo;
		}

		public void ModifyCard(CardInfo card, CardModificationInfo mod)
		{
			card.Mods.Add(mod);
			UpdateModDictionary();
		}

		public void InitializeAsPlayerDeck()
		{
			if (StoryEventsData.EventCompleted(StoryEvent.CageCardDiscovered) && !StoryEventsData.EventCompleted(StoryEvent.WolfCageBroken))
			{
				AddCard(CardLoader.GetCardByName("CagedWolf"));
			}
			else if (StoryEventsData.EventCompleted(StoryEvent.TalkingWolfCardDiscovered))
			{
				AddCard(CardLoader.GetCardByName("Wolf_Talking"));
			}
			else
			{
				AddCard(CardLoader.GetCardByName("Wolf"));
			}
			if (StoryEventsData.EventCompleted(StoryEvent.StinkbugCardDiscovered))
			{
				AddCard(CardLoader.GetCardByName("Stinkbug_Talking"));
			}
			else
			{
				AddCard(CardLoader.GetCardByName("Opossum"));
			}
			AddCard(CardLoader.GetCardByName("Stoat_Talking"));
			AddCard(CardLoader.GetCardByName("Bullfrog"));
		}

		public void FillWithRandomPart1Cards(int deckTier)
		{
			int tickCount = Environment.TickCount;
			for (int i = 0; i < deckTier; i++)
			{
				AddCard(CardLoader.GetRandomChoosableCard(tickCount++));
				AddCard(CardLoader.GetRandomChoosableCard(tickCount++));
				AddCard(CardLoader.GetRandomChoosableCard(tickCount++));
				CardInfo randomRareCard = CardLoader.GetRandomRareCard(CardTemple.Nature);
				while (randomRareCard.portraitTex == null)
				{
					randomRareCard = CardLoader.GetRandomRareCard(CardTemple.Nature);
				}
				AddCard(randomRareCard);
				CardInfo card = AddCard(CardLoader.GetRandomChoosableCard(tickCount++));
				CardModificationInfo cardModificationInfo = new CardModificationInfo();
				cardModificationInfo.fromCardMerge = true;
				cardModificationInfo.abilities.Add(AbilitiesUtil.GetRandomAbility(tickCount++, learned: false, opponentUsable: false, 2, 4));
				ModifyCard(card, cardModificationInfo);
			}
		}

		public bool HasCardsWithBonesCost()
		{
			bool num = base.Cards.Exists((CardInfo x) => x.BonesCost > 0);
			bool flag = base.Cards.Exists((CardInfo x) => x.SpecialAbilities.Contains(SpecialTriggeredAbility.RandomCard));
			return num || flag;
		}

		public bool IsValidGBCDeck()
		{
			return cardIds.Count >= 20;
		}

		protected override void LoadCards()
		{
			base.LoadCards();
			List<CardInfo> moddedCards = new List<CardInfo>();
			foreach (KeyValuePair<string, List<CardModificationInfo>> cardIdModInfo in cardIdModInfos)
			{
				string entryName = cardIdModInfo.Key;
				if (entryName.Contains("#"))
				{
					entryName = entryName.Remove(cardIdModInfo.Key.IndexOf("#"[0]));
				}
				CardInfo cardInfo = base.CardInfos.Find((CardInfo x) => !moddedCards.Contains(x) && entryName == x.name);
				if (cardInfo != null)
				{
					cardInfo.Mods.AddRange(cardIdModInfo.Value);
					moddedCards.Add(cardInfo);
				}
			}
		}

		protected override void OnCardRemoved(CardInfo card)
		{
			UpdateModDictionary();
		}

		private void LoadBoons()
		{
			boons = new List<BoonData>();
			if (boonIds == null)
			{
				boonIds = new List<BoonData.Type>();
			}
			foreach (BoonData.Type boonId in boonIds)
			{
				boons.Add(BoonsUtil.GetData(boonId));
			}
		}

		private void UpdateModDictionary()
		{
			cardIdModInfos.Clear();
			foreach (CardInfo cardInfo in base.CardInfos)
			{
				string key = cardInfo.name;
				int num = 0;
				while (cardIdModInfos.ContainsKey(key))
				{
					num++;
					key = cardInfo.name + "#" + num;
				}
				cardIdModInfos.Add(key, cardInfo.Mods);
			}
		}
	}
}
