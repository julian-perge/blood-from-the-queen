using System;
using System.Collections.Generic;
using Sirenix.OdinInspector;
using UnityEngine;

namespace DiskCardGame
{
	[CreateAssetMenu(fileName = "CardInfo", menuName = "Cards/CardInfo", order = 1)]
	public class CardInfo : SerializedScriptableObject, ICloneable
	{
		[Title("Meta Info", null, TitleAlignments.Left, true, true)]
		public List<CardMetaCategory> metaCategories = new List<CardMetaCategory>();

		public CardComplexity cardComplexity = CardComplexity.Simple;

		public bool onePerDeck;

		[Title("Displayed Info", null, TitleAlignments.Left, true, true)]
		public CardTemple temple;

		[SerializeField]
		private string displayedName;

		public Texture titleGraphic;

		[FoldoutGroup("Description", 0)]
		[TextArea]
		public string description;

		public bool hideAttackAndHealth;

		public List<CardAppearanceBehaviour.Appearance> appearanceBehaviour = new List<CardAppearanceBehaviour.Appearance>();

		[ShowIf("@!appearanceBehaviour.Contains(CardAppearanceBehaviour.Appearance.AnimatedPortrait)", true)]
		[TabGroup("Portrait", false, 0)]
		public Sprite portraitTex;

		[ShowIf("@appearanceBehaviour.Contains(CardAppearanceBehaviour.Appearance.HologramPortrait)", true)]
		[TabGroup("Portrait", false, 0)]
		public GameObject holoPortraitPrefab;

		[ShowIf("@appearanceBehaviour.Contains(CardAppearanceBehaviour.Appearance.AnimatedPortrait) || appearanceBehaviour.Contains(CardAppearanceBehaviour.Appearance.DynamicPortrait)", true)]
		[TabGroup("Portrait", false, 0)]
		[SerializeField]
		private GameObject animatedPortrait;

		[TabGroup("Alternate Portrait", false, 0)]
		public Sprite alternatePortrait;

		[TabGroup("Pixel Portrait", false, 0)]
		public Sprite pixelPortrait;

		[TabGroup("Decals", false, 0)]
		[SerializeField]
		private List<Texture> decals = new List<Texture>();

		[Title("Stats", null, TitleAlignments.Left, true, true)]
		[SerializeField]
		private int baseAttack;

		[SerializeField]
		private int baseHealth;

		[BoxGroup]
		[SerializeField]
		private int cost;

		[BoxGroup]
		[SerializeField]
		private int bonesCost;

		[BoxGroup]
		[SerializeField]
		private int energyCost;

		[BoxGroup]
		[SerializeField]
		private List<GemType> gemsCost = new List<GemType>();

		[SerializeField]
		private SpecialStatIcon specialStatIcon;

		public BoonData.Type boon;

		[Title("Ability Params", null, TitleAlignments.Left, true, true)]
		public List<Tribe> tribes = new List<Tribe>();

		public List<Trait> traits = new List<Trait>();

		[FoldoutGroup("Abilities", 0)]
		[SerializeField]
		private List<SpecialTriggeredAbility> specialAbilities = new List<SpecialTriggeredAbility>();

		[FoldoutGroup("Abilities", 0)]
		[SerializeField]
		private List<Ability> abilities = new List<Ability>();

		[FoldoutGroup("Specific Ability Params", 0)]
		public EvolveParams evolveParams;

		[FoldoutGroup("Specific Ability Params", 0)]
		public string defaultEvolutionName;

		[FoldoutGroup("Specific Ability Params", 0)]
		public TailParams tailParams;

		[FoldoutGroup("Specific Ability Params", 0)]
		public IceCubeParams iceCubeParams;

		[FoldoutGroup("Specific Ability Params", 0)]
		public bool flipPortraitForStrafe;

		private List<CardModificationInfo> mods = new List<CardModificationInfo>();

		private List<Texture> temporaryDecals = new List<Texture>();

		private List<Texture> get_decals = new List<Texture>();

		public List<CardModificationInfo> Mods
		{
			get
			{
				return mods;
			}
			set
			{
				mods = value;
			}
		}

		public List<Texture> TempDecals => temporaryDecals;

		public GameObject AnimatedPortrait
		{
			get
			{
				if (animatedPortrait != null)
				{
					StoryEventAlternatePrefabs component = animatedPortrait.GetComponent<StoryEventAlternatePrefabs>();
					if (component != null)
					{
						return component.GetAlternatePrefab();
					}
				}
				return animatedPortrait;
			}
		}

		public List<Texture> Decals
		{
			get
			{
				get_decals.Clear();
				get_decals.AddRange(decals);
				get_decals.AddRange(temporaryDecals);
				foreach (CardModificationInfo mod in Mods)
				{
					foreach (string decalId in mod.DecalIds)
					{
						get_decals.Add(ResourceBank.Get<Texture>("Art/Cards/Decals/" + decalId));
					}
				}
				return get_decals;
			}
		}

		public string DisplayedNameEnglish
		{
			get
			{
				string nameReplacement = displayedName;
				foreach (CardModificationInfo mod in Mods)
				{
					if (!string.IsNullOrEmpty(mod.nameReplacement))
					{
						nameReplacement = mod.nameReplacement;
					}
				}
				return nameReplacement;
			}
		}

		public string DisplayedNameLocalized => Localization.Translate(DisplayedNameEnglish);

		public int Attack
		{
			get
			{
				int attack = baseAttack;
				Mods.ForEach(delegate(CardModificationInfo x)
				{
					attack += x.attackAdjustment;
				});
				if (specialAbilities.Contains(SpecialTriggeredAbility.Ouroboros))
				{
					attack += SaveManager.SaveFile.ouroborosDeaths;
				}
				return attack;
			}
		}

		public int Health
		{
			get
			{
				int health = baseHealth;
				Mods.ForEach(delegate(CardModificationInfo x)
				{
					health += x.healthAdjustment;
				});
				if (specialAbilities.Contains(SpecialTriggeredAbility.Ouroboros))
				{
					health += SaveManager.SaveFile.ouroborosDeaths;
				}
				return health;
			}
		}

		public int BloodCost
		{
			get
			{
				int c = cost;
				Mods.ForEach(delegate(CardModificationInfo x)
				{
					c += x.bloodCostAdjustment;
				});
				return c;
			}
		}

		public int BonesCost
		{
			get
			{
				int c = bonesCost;
				Mods.ForEach(delegate(CardModificationInfo x)
				{
					c += x.bonesCostAdjustment;
				});
				return c;
			}
		}

		public int EnergyCost
		{
			get
			{
				int c = energyCost;
				Mods.ForEach(delegate(CardModificationInfo x)
				{
					c += x.energyCostAdjustment;
				});
				return c;
			}
		}

		public List<GemType> GemsCost
		{
			get
			{
				gemsCost = new List<GemType>(gemsCost);
				if (Mods.Exists((CardModificationInfo x) => x.nullifyGemsCost))
				{
					return new List<GemType>();
				}
				foreach (CardModificationInfo mod in Mods)
				{
					if (mod.addGemCost == null)
					{
						continue;
					}
					foreach (GemType item in mod.addGemCost)
					{
						if (!gemsCost.Contains(item))
						{
							gemsCost.Add(item);
						}
					}
				}
				return gemsCost;
			}
		}

		public bool Gemified => Mods.Exists((CardModificationInfo x) => x.gemify);

		public int CostTier => BloodCost + Mathf.RoundToInt((float)BonesCost / 3f) + Mathf.RoundToInt((float)energyCost / 2f) + gemsCost.Count;

		public bool Sacrificable
		{
			get
			{
				if (!traits.Contains(Trait.Pelt))
				{
					return !traits.Contains(Trait.Terrain);
				}
				return false;
			}
		}

		public int PowerLevel
		{
			get
			{
				int abilitiesPower = 0;
				Abilities.ForEach(delegate(Ability x)
				{
					abilitiesPower += AbilitiesUtil.GetInfo(x).powerLevel;
				});
				return Attack * 2 + Health + abilitiesPower;
			}
		}

		public List<Ability> DefaultAbilities => abilities;

		public List<Ability> ModAbilities => AbilitiesUtil.GetAbilitiesFromMods(Mods);

		public List<Ability> Abilities
		{
			get
			{
				List<Ability> abilities = new List<Ability>();
				abilities.AddRange(DefaultAbilities);
				abilities.AddRange(ModAbilities);
				Mods.ForEach(delegate(CardModificationInfo m)
				{
					m.negateAbilities?.ForEach(delegate(Ability a)
					{
						abilities.Remove(a);
					});
				});
				return abilities;
			}
		}

		public List<SpecialTriggeredAbility> SpecialAbilities
		{
			get
			{
				List<SpecialTriggeredAbility> list = new List<SpecialTriggeredAbility>();
				list.AddRange(specialAbilities);
				foreach (CardModificationInfo mod in Mods)
				{
					list.AddRange(mod.specialAbilities);
				}
				return list;
			}
		}

		public SpecialStatIcon SpecialStatIcon
		{
			get
			{
				foreach (CardModificationInfo mod in Mods)
				{
					if (mod.statIcon != 0)
					{
						return mod.statIcon;
					}
				}
				return specialStatIcon;
			}
		}

		public int NumAbilities => Abilities.Count;

		public object Clone()
		{
			CardInfo obj = (CardInfo)MemberwiseClone();
			obj.Mods = new List<CardModificationInfo>();
			return obj;
		}

		public override bool Equals(object other)
		{
			return this == other;
		}

		public override int GetHashCode()
		{
			return base.GetHashCode();
		}

		public bool IsOfTribe(Tribe tribe)
		{
			return tribes.Contains(tribe);
		}

		public bool HasTrait(Trait trait)
		{
			return traits.Contains(trait);
		}

		public bool HasAbility(Ability ability)
		{
			return Abilities.Contains(ability);
		}

		public bool HasConduitAbility()
		{
			return Abilities.Exists((Ability x) => AbilitiesUtil.GetInfo(x).conduit);
		}

		public bool HasCellAbility()
		{
			return Abilities.Exists((Ability x) => AbilitiesUtil.GetInfo(x).conduitCell);
		}

		public void RemoveBaseAbility(Ability ability)
		{
			abilities.Remove(ability);
		}

		public bool HasModFromCardMerge()
		{
			return Mods.Exists((CardModificationInfo x) => x.fromCardMerge);
		}
	}
}
