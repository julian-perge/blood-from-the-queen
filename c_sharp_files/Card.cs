using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace DiskCardGame
{
	public class Card : MainInputInteractable
	{
		[SerializeField]
		private CardAbilityIcons abilityIcons;

		[SerializeField]
		private CardStatIcons statIcons;

		[SerializeField]
		private Texture defaultCardback;

		private bool exitingBoard;

		public CardInfo Info { get; set; }

		public RenderStatsLayer StatsLayer => GetComponentInChildren<RenderStatsLayer>(includeInactive: true);

		public CardRenderInfo RenderInfo { get; } = new CardRenderInfo();

		public CardAnimationController Anim => GetComponent<CardAnimationController>();

		public bool FaceDown { get; private set; }

		public CardAbilityIcons AbilityIcons => abilityIcons;

		public void EnterBoard(float tweenLength, Vector3 startPointOffset)
		{
			Anim.EnterBoard(tweenLength, startPointOffset);
		}

		public virtual void ExitBoard(float tweenLength, Vector3 destinationOffset)
		{
			if (!exitingBoard)
			{
				exitingBoard = true;
				Anim.ExitBoard(tweenLength, destinationOffset);
				UnityEngine.Object.Destroy(base.gameObject, tweenLength);
			}
		}

		public virtual void SetInfo(CardInfo info)
		{
			Info = info;
			if (!string.IsNullOrEmpty(info.DisplayedNameEnglish))
			{
				base.gameObject.name = "Card (" + info.DisplayedNameEnglish + ")";
			}
			RenderInfo.baseInfo = info;
			RenderInfo.attack = info.Attack;
			RenderInfo.health = info.Health;
			RenderInfo.energyCost = info.EnergyCost;
			ApplyAppearanceBehaviours(info.appearanceBehaviour);
			RenderCard();
			AttachAbilities(info);
		}

		public void RenderCard()
		{
			UpdateAppearanceBehaviours();
			StatsLayer.RenderCard(RenderInfo);
			UpdateInteractableIcons();
		}

		public void SetFaceDown(bool faceDown, bool immediate = false)
		{
			FaceDown = faceDown;
			Anim.SetFaceDown(faceDown, immediate);
			SetInteractionEnabled(!faceDown);
		}

		public void SetInteractionEnabled(bool interactionEnabled)
		{
			if (abilityIcons != null)
			{
				abilityIcons.SetInteractionEnabled(interactionEnabled);
			}
			if (statIcons != null)
			{
				statIcons.SetInteractionEnabled(interactionEnabled);
			}
		}

		public void ClearAppearanceBehaviours()
		{
			CardAppearanceBehaviour[] components = GetComponents<CardAppearanceBehaviour>();
			foreach (CardAppearanceBehaviour obj in components)
			{
				obj.ResetAppearance();
				UnityEngine.Object.Destroy(obj);
			}
		}

		public void SetCardback(Texture texture)
		{
			StatsLayer.SetCardBackTexture(texture);
		}

		public void SetCardbackToDefault()
		{
			SetCardback(defaultCardback);
		}

		public virtual void SetCardbackSubmerged()
		{
			SetCardback(ResourceBank.Get<Texture>("Art/Cards/card_back_submerge"));
		}

		public virtual void AddPermanentBehaviour<T>() where T : SpecialCardBehaviour
		{
			CardTriggerHandler.AddReceiverToGameObject<T>(typeof(T).Name, base.gameObject);
		}

		public void UpdateInteractableIcons()
		{
			if (abilityIcons != null)
			{
				List<Ability> hiddenAbilities = null;
				if (this is PlayableCard)
				{
					hiddenAbilities = (this as PlayableCard).Status.hiddenAbilities;
				}
				abilityIcons.UpdateAbilityIcons(RenderInfo.baseInfo, RenderInfo.temporaryMods, this as PlayableCard, hiddenAbilities);
			}
			if (statIcons != null)
			{
				statIcons.UpdateIconsActive(StatIconInfo.IconAppliesToAttack(RenderInfo.baseInfo.SpecialStatIcon), StatIconInfo.IconAppliesToHealth(RenderInfo.baseInfo.SpecialStatIcon));
				statIcons.AssignStatIcon(RenderInfo.baseInfo.SpecialStatIcon, this as PlayableCard);
			}
		}

		protected virtual void AttachAbilities(CardInfo info)
		{
			Debug.Log("Called AttachAbilities in Card");
			foreach (SpecialTriggeredAbility specialAbility in info.SpecialAbilities)
			{
				CardTriggerHandler.AddReceiverToGameObject<SpecialCardBehaviour>(specialAbility.ToString(), base.gameObject);
			}
		}

		protected IEnumerator FlipCardbackTexture(Texture cardbackTexture)
		{
			Anim.FakeFlipFacedown();
			yield return new WaitForSeconds(0.083f);
			SetCardback(cardbackTexture);
		}

		protected virtual void ApplyAppearanceBehaviours(List<CardAppearanceBehaviour.Appearance> appearances)
		{
			foreach (CardAppearanceBehaviour.Appearance appearance in appearances)
			{
				Type type = CustomType.GetType("DiskCardGame", appearance.ToString());
				if (!base.gameObject.GetComponent(type))
				{
					(base.gameObject.AddComponent(type) as CardAppearanceBehaviour).ApplyAppearance();
				}
			}
		}

		private void UpdateAppearanceBehaviours()
		{
			CardAppearanceBehaviour[] components = GetComponents<CardAppearanceBehaviour>();
			for (int i = 0; i < components.Length; i++)
			{
				components[i].OnPreRenderCard();
			}
		}
	}
}
