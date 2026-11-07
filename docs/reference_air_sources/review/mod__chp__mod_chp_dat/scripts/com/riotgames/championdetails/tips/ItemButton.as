package com.riotgames.championdetails.tips
{
   import blix.assets.proxy.tipsScreen.ItemIconButton;
   import blix.components.button.ButtonX;
   import blix.components.loader.ImageX;
   import blix.components.tooltip.assignToolTip;
   import blix.components.tooltip.unassignToolTip;
   import blix.context.Context;
   import com.riotgames.championdetails.IChampionDetailsContext;
   import com.riotgames.championdetails.tooltip.DescriptiveToolTip;
   import com.riotgames.championdetails.tooltip.DescriptiveToolTipModel;
   import com.riotgames.championdetails.tooltip.TweenedToolTipHandler;
   import com.riotgames.gameItems.model.GameItem;
   import flash.display.MovieClip;
   import flash.net.URLRequest;
   
   public class ItemButton extends ButtonX
   {
      
      private var image:ImageX;
      
      private var _model:GameItem;
      
      private var customToolTip:DescriptiveToolTip;
      
      public function ItemButton(param1:Context, param2:MovieClip = null)
      {
         super(param1,param2);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:ItemIconButton = new ItemIconButton();
         this.image = new ImageX(this);
         setTimelineChild(_loc1_.iconHolder,this.image);
         this.customToolTip = new DescriptiveToolTip(this);
      }
      
      public function getModel() : GameItem
      {
         return this._model;
      }
      
      public function setModel(param1:GameItem) : void
      {
         var _loc3_:DescriptiveToolTipModel = null;
         this._model = param1;
         var _loc2_:IChampionDetailsContext = getFirstContext(IChampionDetailsContext);
         if(this._model != null)
         {
            this.image.load(new URLRequest(_loc2_.getConfig().itemAssetsPath + this._model.icon));
            _loc3_ = new DescriptiveToolTipModel(this._model.name,"",this._model.totalPrice.toString(),this._model.description);
            assignToolTip(this,_loc3_,new TweenedToolTipHandler(this.customToolTip,1,0));
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         unassignToolTip(this);
      }
      
      override public function setData(param1:*) : void
      {
         super.setData(param1);
         this.setModel(param1);
      }
   }
}

