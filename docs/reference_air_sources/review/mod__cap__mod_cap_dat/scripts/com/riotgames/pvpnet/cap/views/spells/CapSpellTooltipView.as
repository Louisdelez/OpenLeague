package com.riotgames.pvpnet.cap.views.spells
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.renderer.IDataRenderer;
   import blix.context.IContext;
   import blix.layout.LayoutContainerView;
   import blix.layout.algorithms.VerticalLayout;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.Spell;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   import mx.resources.ResourceManager;
   
   public class CapSpellTooltipView extends SpriteProxy implements IDataRenderer
   {
      
      private var _spellDescriptionText:TextFieldProxy;
      
      private var _spellNameText:TextFieldProxy;
      
      private var _spellRequirementText:TextFieldProxy;
      
      private var _spell:Spell;
      
      private var _background:SpriteProxy;
      
      private var _arrow:SpriteProxy;
      
      private var _textContainer:LayoutContainerView;
      
      public function CapSpellTooltipView(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2);
         setLinkage("SummonerSpellTooltip");
      }
      
      private function setSpell(param1:Spell) : void
      {
         if(param1 == this._spell)
         {
            return;
         }
         this._spell = param1;
         this._spellNameText.setText(RiotResourceLoader.getSpellResourceString("name",this._spell.name,"**" + this._spell.name));
         this._spellRequirementText.setText(ResourceManager.getInstance().getString("resources","talentTree_requirements_summonerLevel",[this._spell.minLevel]));
         this._spellDescriptionText.setText(RiotResourceLoader.getSpellResourceString("description",this._spell.name,"**" + this._spell.name));
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this._textContainer.setExplicitSize(NaN,NaN);
         this._background.setExplicitSize(NaN,_loc3_.y + 23);
         this._arrow.setExplicitPosition(NaN,this._background.getY() + this._background.getHeight() / 2 - this._arrow.getHeight() / 2);
         return new Rectangle(0,0,this._background.getX() + this._background.getWidth(),this._background.getY() + this._background.getHeight());
      }
      
      public function setData(param1:*) : void
      {
         this.setSpell(param1);
      }
      
      public function getData() : *
      {
         return this._spell;
      }
      
      override protected function createChildren() : void
      {
         this._textContainer = new LayoutContainerView(this);
         this._textContainer.setLayoutAlgorithm(new VerticalLayout());
         setTimelineChildByName("textContainer",this._textContainer);
         this._background = new SpriteProxy(this);
         this._background.setTransformBehavior(new ScalingTransformBehavior());
         setTimelineChildByName("background",this._background);
         this._arrow = new SpriteProxy(this);
         setTimelineChildByName("arrow",this._arrow);
         this._spellNameText = new TextFieldProxy(this);
         this._spellNameText.setAutoSize(TextFieldAutoSize.LEFT);
         this._textContainer.setTimelineChildByName("spellName",this._spellNameText);
         this._textContainer.addElement(this._spellNameText);
         this._spellRequirementText = new TextFieldProxy(this);
         this._spellRequirementText.setAutoSize(TextFieldAutoSize.LEFT);
         this._textContainer.setTimelineChildByName("spellRequirement",this._spellRequirementText);
         this._textContainer.addElement(this._spellRequirementText);
         this._spellDescriptionText = new TextFieldProxy(this);
         this._spellDescriptionText.setAutoSize(TextFieldAutoSize.LEFT);
         this._textContainer.setTimelineChildByName("spellDescription",this._spellDescriptionText);
         this._textContainer.addElement(this._spellDescriptionText);
         super.createChildren();
      }
   }
}

