package com.riotgames.platform.gameclient.controllers.game.views.popup
{
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.controls.Button;
   import mx.controls.CheckBox;
   import mx.controls.Label;
   import mx.controls.Text;
   import mx.core.UIComponent;
   
   public class TipPopup extends UIComponent
   {
      
      private static const DEFAULT_WIDTH:Number = 260;
      
      private static const DEFAULT_HEIGHT:Number = 135;
      
      protected var footerLabel:Label;
      
      protected var tipChanged:Boolean = false;
      
      protected var divider:ListLineDivider;
      
      protected var _tipText:Text;
      
      private var _header:String = "";
      
      protected var footerChanged:Boolean = false;
      
      protected var toggleCheckbox:CheckBox;
      
      protected var _tipType:String = "newbie";
      
      private var _footer:String = "";
      
      protected var closeButton:Button;
      
      private var _tip:String = "";
      
      protected var headerLabel:Label;
      
      protected var headerChanged:Boolean = false;
      
      public function TipPopup()
      {
         super();
         this.styleName = "stoneTablet";
      }
      
      protected function createFooterLabel() : void
      {
         this.footerLabel = new Label();
         this.footerLabel.styleName = "newbieTipFooter";
         this.footerLabel.setStyle("textAlign","right");
         if(this.footer == null || this.footer == "")
         {
            this.footerLabel.text = resourceManager.getString("resources","newbieTip_footer_toggleOff");
         }
      }
      
      public function get header() : String
      {
         return this._header;
      }
      
      protected function onCloseClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      protected function drawBackground(param1:Number, param2:Number) : void
      {
         var _loc3_:* = getStyle("backgroundColor");
         var _loc4_:* = getStyle("backgroundAlpha");
         var _loc5_:* = getStyle("borderColor");
         var _loc6_:* = getStyle("borderThickness");
         var _loc7_:* = getStyle("borderStyle");
         if(_loc3_ == null)
         {
            _loc3_ = 0;
         }
         else if(_loc4_ == null)
         {
            _loc4_ = 1;
         }
         _loc4_ = 1;
         graphics.clear();
         graphics.lineStyle(_loc6_,_loc5_);
         graphics.beginFill(_loc3_,_loc4_);
         graphics.drawRoundRect(0,0,param1,param2,5);
         graphics.endFill();
      }
      
      public function set header(param1:String) : void
      {
         if(this._header == param1)
         {
            return;
         }
         this._header = param1;
         this.headerChanged = true;
         invalidateProperties();
      }
      
      public function get tip() : String
      {
         return this._tip;
      }
      
      public function get footer() : String
      {
         return this._footer;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!this.closeButton)
         {
            this.createCloseButton();
            if(this.closeButton)
            {
               addChild(this.closeButton);
            }
         }
         if(!this.headerLabel)
         {
            this.createHeaderLabel();
            if(this.headerLabel)
            {
               addChild(this.headerLabel);
            }
         }
         if(!this._tipText)
         {
            this.createTipText();
            if(this._tipText)
            {
               addChild(this._tipText);
            }
         }
         if(!this.divider)
         {
            this.createDivider();
            if(this.divider)
            {
               addChild(this.divider);
            }
         }
         if(!this.footerLabel)
         {
            this.createFooterLabel();
            if(this.footerLabel)
            {
               addChild(this.footerLabel);
            }
         }
         if(!this.toggleCheckbox)
         {
            this.createToggleCheckBox();
            if(this.toggleCheckbox)
            {
               addChild(this.toggleCheckbox);
            }
         }
      }
      
      protected function createCloseButton() : void
      {
         this.closeButton = new Button();
         this.closeButton.styleName = "chooseGameExitButton";
         this.closeButton.buttonMode = true;
         this.closeButton.addEventListener(MouseEvent.CLICK,this.onCloseClicked);
      }
      
      protected function createToggleCheckBox() : void
      {
         this.toggleCheckbox = new CheckBox();
         this.toggleCheckbox.selected = !UserPreferencesManager.userPrefs.newbieTipsEnabled;
         this.toggleCheckbox.addEventListener(MouseEvent.CLICK,this.onPreferencesChanged);
      }
      
      public function set footer(param1:String) : void
      {
         if(this._footer == param1)
         {
            return;
         }
         this._footer = param1;
         this.footerChanged = true;
         invalidateProperties();
      }
      
      public function set tip(param1:String) : void
      {
         if(this._tip == param1)
         {
            return;
         }
         this._tip = param1;
         this.tipChanged = true;
         invalidateProperties();
      }
      
      protected function createHeaderLabel() : void
      {
         this.headerLabel = new Label();
         this.headerLabel.styleName = "newbieTipHeaderText";
         this.headerLabel.setStyle("textAlign","center");
      }
      
      protected function createTipText() : void
      {
         this._tipText = new Text();
         this._tipText.styleName = "newbieTipText";
         this._tipText.selectable = false;
         this.headerLabel.setStyle("textAlign","left");
      }
      
      public function set tipText(param1:Text) : void
      {
         this._tipText = param1;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.tipChanged && Boolean(this._tipText))
         {
            this._tipText.text = this.tip;
            this.tipChanged = false;
         }
         if(this.headerChanged && Boolean(this.headerLabel))
         {
            this.headerLabel.text = this.header;
            this.headerChanged = false;
         }
         if(this.footerChanged && Boolean(this.footerLabel))
         {
            this.footerLabel.text = this.footer;
            this.footerChanged = false;
         }
      }
      
      protected function onPreferencesChanged(param1:MouseEvent) : void
      {
         UserPreferencesManager.userPrefs.newbieTipsEnabled = !this.toggleCheckbox.selected;
      }
      
      override protected function measure() : void
      {
         measuredWidth = measuredMinWidth = DEFAULT_WIDTH;
         measuredHeight = measuredMinHeight = DEFAULT_HEIGHT;
      }
      
      public function get tipText() : Text
      {
         return this._tipText;
      }
      
      override protected function childrenCreated() : void
      {
         super.childrenCreated();
         if(this.tipChanged && Boolean(this._tipText))
         {
            this._tipText.text = this.tip;
            this.tipChanged = false;
         }
         if(this.headerChanged && Boolean(this.headerLabel))
         {
            this.headerLabel.text = this.header;
            this.headerChanged = false;
         }
         if(this.footerChanged && Boolean(this.footerLabel))
         {
            this.footerLabel.text = this.footer;
            this.footerChanged = false;
         }
      }
      
      public function set tipType(param1:String) : void
      {
         this._tipType = param1;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = param1;
         var _loc4_:Number = param2;
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         if(this.closeButton)
         {
            _loc5_ = Number(this.closeButton.getExplicitOrMeasuredWidth());
            _loc6_ = Number(this.closeButton.getExplicitOrMeasuredHeight());
            this.closeButton.setActualSize(_loc5_,_loc6_);
            this.closeButton.move(param1 - _loc5_,0);
         }
         var _loc7_:Number = 0;
         var _loc8_:Number = 0;
         if(this.headerLabel)
         {
            _loc7_ = param1 - 26;
            _loc8_ = Number(this.headerLabel.getExplicitOrMeasuredHeight());
            this.headerLabel.setActualSize(_loc7_,_loc8_);
            this.headerLabel.move(1,5);
         }
         _loc4_ -= Math.max(_loc6_,_loc8_ + 1);
         var _loc9_:Number = 0;
         if(this.divider)
         {
            this.divider.setActualSize(param1 * 0.9,NaN);
            _loc12_ = Number(this.divider.getExplicitOrMeasuredWidth());
            _loc9_ = 21;
            this.divider.move(param1 - _loc12_ / 2,param2 - 21);
         }
         _loc4_ -= _loc9_;
         if(this._tipText)
         {
            _loc13_ = 0.98 * param1;
            _loc14_ = _loc4_;
            this._tipText.setActualSize(_loc13_,_loc14_);
            this._tipText.move((param1 - _loc13_) / 2,param2 - _loc9_ - _loc14_);
         }
         var _loc10_:Number = 0;
         var _loc11_:Number = 0;
         if(this.toggleCheckbox)
         {
            _loc10_ = Number(this.toggleCheckbox.getExplicitOrMeasuredWidth());
            _loc11_ = Number(this.toggleCheckbox.getExplicitOrMeasuredHeight());
            this.toggleCheckbox.setActualSize(_loc10_,_loc11_);
            this.toggleCheckbox.move(param1 - _loc10_ - 5,param2 - _loc11_ - 4);
         }
         if(this.footerLabel)
         {
            _loc15_ = param1 - _loc10_ - 16;
            _loc16_ = Number(this.footerLabel.getExplicitOrMeasuredHeight());
            this.footerLabel.setActualSize(_loc15_,_loc16_);
            this.footerLabel.move(1,param2 - _loc16_ - 1);
         }
         this.drawBackground(param1,param2);
      }
      
      public function get tipType() : String
      {
         return this._tipType;
      }
      
      protected function createDivider() : void
      {
         this.divider = new ListLineDivider();
      }
   }
}

