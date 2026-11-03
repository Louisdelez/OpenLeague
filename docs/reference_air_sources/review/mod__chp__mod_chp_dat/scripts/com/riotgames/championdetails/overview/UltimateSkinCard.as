package com.riotgames.championdetails.overview
{
   import blix.context.IContext;
   import blix.model.TextModel;
   
   public class UltimateSkinCard extends SkinCard
   {
      
      private var ultimateRollout:UltimateRollout;
      
      public function UltimateSkinCard(param1:IContext)
      {
         super(param1);
         setLinkage("assets.UltimateSkinCardAsset");
         this.ultimateRollout.close();
         var _loc2_:Vector.<Function> = new Vector.<Function>(1,true);
         _loc2_[0] = this.addFontTag;
         this.ultimateRollout.featuresText.setTextDecorators(_loc2_);
      }
      
      private function addFontTag(param1:String) : String
      {
         return "<font face=\'ApplicationFont1\'>" + param1 + "</font>";
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.ultimateRollout = new UltimateRollout(this);
         setTimelineChildByName("ultimateRollout",this.ultimateRollout);
      }
      
      public function setFeaturesText(param1:TextModel) : void
      {
         this.ultimateRollout.featuresText.setTextModel(param1,true);
      }
      
      override public function setSelected(param1:Boolean) : void
      {
         super.setSelected(param1);
         if(param1)
         {
            setCurrentState("selected");
            this.ultimateRollout.show();
         }
         else
         {
            setCurrentState("unselected");
            this.ultimateRollout.hide();
         }
      }
   }
}

