package com.riotgames.platform.gameclient.views.game.common.endofgame
{
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.platform.gameclient.views.game.common.ChampionImages;
   import flash.events.Event;
   import mx.containers.Canvas;
   import mx.controls.CheckBox;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   
   public class EndOfGameGridCheckBox extends Canvas
   {
      
      private var _1282089978_selected:Boolean = true;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {
               "width":200,
               "height":25,
               "childDescriptors":[new UIComponentDescriptor({
                  "type":CheckBox,
                  "id":"checkBox",
                  "events":{
                     "creationComplete":"__checkBox_creationComplete",
                     "change":"__checkBox_change"
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "styleName":"blueCheckBox",
                        "y":1,
                        "tabEnabled":false
                     };
                  }
               })]
            };
         }
      });
      
      private var _1536861091checkBox:CheckBox;
      
      public function EndOfGameGridCheckBox()
      {
         super();
         mx_internal::_document = this;
         this.width = 200;
         this.height = 25;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
      }
      
      public function __checkBox_creationComplete(param1:FlexEvent) : void
      {
         this.checkBox.selected = this._selected;
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:PlayerParticipantStatsSummary = null;
         var _loc3_:Image = null;
         var _loc4_:Label = null;
         super.data = param1;
         if(data is PlayerParticipantStatsSummary)
         {
            _loc2_ = data as PlayerParticipantStatsSummary;
            _loc3_ = new Image();
            _loc3_.source = ChampionImages.getIconPath(_loc2_.skinName);
            _loc3_.height = 23;
            _loc3_.maintainAspectRatio = true;
            _loc3_.x = 23;
            _loc3_.smoothBitmapContent = true;
            _loc3_.toolTip = _loc2_.summonerName;
            this.addChild(_loc3_);
            _loc4_ = new Label();
            _loc4_.height = 20;
            _loc4_.width = 200;
            _loc4_.y = 1;
            _loc4_.x = _loc3_.x + _loc3_.height + 3;
            _loc4_.selectable = false;
            _loc4_.setStyle("fontSize",14);
            _loc4_.setStyle("color",16777215);
            _loc4_.setStyle("textAlign","left");
            _loc4_.text = _loc2_.summonerName;
            this.addChild(_loc4_);
         }
      }
      
      public function __checkBox_change(param1:Event) : void
      {
         this.selected = this.checkBox.selected;
         this.dispatchEvent(new Event("change"));
      }
      
      private function set _selected(param1:Boolean) : void
      {
         var _loc2_:Object = this._1282089978_selected;
         if(_loc2_ !== param1)
         {
            this._1282089978_selected = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_selected",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get checkBox() : CheckBox
      {
         return this._1536861091checkBox;
      }
      
      public function set checkBox(param1:CheckBox) : void
      {
         var _loc2_:Object = this._1536861091checkBox;
         if(_loc2_ !== param1)
         {
            this._1536861091checkBox = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"checkBox",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         super.initialize();
      }
      
      [Bindable(event="propertyChange")]
      private function get _selected() : Boolean
      {
         return this._1282089978_selected;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
         if(this.checkBox)
         {
            this.checkBox.selected = param1;
         }
      }
   }
}

