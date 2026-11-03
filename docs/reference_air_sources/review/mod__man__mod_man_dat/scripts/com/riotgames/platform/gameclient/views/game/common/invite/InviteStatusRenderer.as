package com.riotgames.platform.gameclient.views.game.common.invite
{
   import mx.controls.Label;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.UIComponent;
   
   public class InviteStatusRenderer extends UIComponent implements IListItemRenderer
   {
      
      protected var statusLabel:Label;
      
      protected var _data:Object;
      
      protected var nameLabel:Label;
      
      protected var dataChanged:Boolean = false;
      
      public function InviteStatusRenderer()
      {
         super();
      }
      
      protected function updateNameLabel() : void
      {
         if(this.nameLabel)
         {
            this.nameLabel.htmlText = this.data.name;
         }
      }
      
      protected function createStatusLabel() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.setStyle("textAlign","right");
         return _loc1_;
      }
      
      protected function updateStatusLabel() : void
      {
         if(this.statusLabel)
         {
            this.statusLabel.htmlText = this.data.displayStatus;
            this.statusLabel.setStyle("color",this.data.getColor());
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.dataChanged)
         {
            this.updateNameLabel();
            this.updateStatusLabel();
            this.dataChanged = false;
         }
      }
      
      protected function createNameLabel() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.setStyle("textAlign","left");
         _loc1_.setStyle("color",15658734);
         return _loc1_;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
         this.dataChanged = true;
         invalidateProperties();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(this.nameLabel)
         {
            _loc3_ = Number(this.nameLabel.getExplicitOrMeasuredWidth());
            _loc4_ = Number(this.nameLabel.getExplicitOrMeasuredHeight());
            this.nameLabel.setActualSize(_loc3_,_loc4_);
            this.nameLabel.move(0,(param2 - _loc4_) / 2);
         }
         if(this.statusLabel)
         {
            _loc5_ = Number(this.statusLabel.getExplicitOrMeasuredWidth());
            _loc6_ = Number(this.statusLabel.getExplicitOrMeasuredHeight());
            this.statusLabel.setActualSize(_loc5_,_loc6_);
            this.statusLabel.move(param1 - _loc5_,(param2 - _loc6_) / 2);
         }
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!this.nameLabel)
         {
            this.nameLabel = this.createNameLabel();
            addChild(this.nameLabel);
         }
         if(!this.statusLabel)
         {
            this.statusLabel = this.createStatusLabel();
            addChild(this.statusLabel);
         }
      }
   }
}

