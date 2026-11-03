package com.riotgames.pvpnet.cap.views.spells
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.ButtonX;
   import blix.components.text.Text;
   import blix.context.IContext;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.Spell;
   import flash.geom.Rectangle;
   
   public class CapSpellSelectIconRenderer extends ButtonX
   {
      
      private var _iconSizer:SpriteProxy;
      
      private var _spell:Spell;
      
      private var _label:Text;
      
      private var _icon:DisplayObjectProxy;
      
      public function CapSpellSelectIconRenderer(param1:IContext, param2:Spell)
      {
         super(param1);
         setLinkage("SpellSelectIcon");
         this.setSpell(param2);
      }
      
      public function getSpell() : Spell
      {
         return this._spell;
      }
      
      private function setSpell(param1:Spell) : void
      {
         this._spell = param1;
         if(param1 != null)
         {
            this._icon.setAsset(ImagePackLookup.instance.getSpellBitmap(param1));
            this._label.setText(RiotResourceLoader.getSpellResourceString("name",this._spell.name,"**" + this._spell.name));
         }
         else
         {
            this._icon.setAsset(null);
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._icon.setExplicitSize(this._iconSizer.getWidth(),this._iconSizer.getHeight());
         this._icon.setExplicitPosition(this._iconSizer.getX(),this._iconSizer.getY());
         return super.updateLayout(param1,param2);
      }
      
      override protected function createChildren() : void
      {
         this._iconSizer = new SpriteProxy(this);
         setTimelineChildByName("sizer",this._iconSizer);
         this._label = new Text(this);
         setTimelineChildByName("label",this._label);
         this._label.setTruncateToFit(true);
         this._icon = new DisplayObjectProxy(this);
         this._icon.setTransformBehavior(new ScalingTransformBehavior());
         addChild(this._icon);
      }
   }
}

