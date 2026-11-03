package com.riotgames.platform.gameclient.views.game.common.endofgame
{
   import com.riotgames.platform.common.ImagePackLookup;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import mx.containers.Canvas;
   import mx.controls.CheckBox;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class EndOfGameAccordionHeaderRenderer extends Canvas
   {
      
      public static const GROUP_SEPERATOR:Class = EndOfGameAccordionHeaderRenderer_GROUP_SEPERATOR;
      
      public var checkBox:CheckBox;
      
      private var categoryOpen:Boolean = true;
      
      private var openImage:Image;
      
      private var displayLabel:Label;
      
      public var childCanvas:Canvas;
      
      private var closedImage:Image;
      
      public function EndOfGameAccordionHeaderRenderer()
      {
         super();
         setStyle("textAlign","left");
         setStyle("textIndent","15");
         this.closedImage = new Image();
         this.openImage = new Image();
         this.closedImage.source = ImagePackLookup.instance.getClassFromSwfRef("e_friendList_seperatorPlus");
         this.openImage.source = ImagePackLookup.instance.getClassFromSwfRef("e_friendList_seperatorMinus");
         this.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         this.horizontalScrollPolicy = "off";
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:CheckBox = null;
         var _loc4_:Number = NaN;
         if(param1.target is CheckBox)
         {
            this.checkBox.setStyle("iconColor",0);
            return;
         }
         if(Boolean(this.childCanvas) && this.data.name == this.childCanvas.data.name)
         {
            this.categoryOpen = !this.categoryOpen;
            if(this.categoryOpen)
            {
               _loc2_ = 0;
               while(_loc2_ < this.childCanvas.numChildren)
               {
                  _loc3_ = this.childCanvas.getChildAt(_loc2_) as CheckBox;
                  if(_loc3_ != null)
                  {
                     _loc4_ = Number(_loc3_.getStyle("glowColor"));
                     if(_loc3_.selected)
                     {
                        _loc3_.filters = [new GlowFilter(_loc4_,0.7)];
                     }
                     else
                     {
                        _loc3_.filters = null;
                     }
                  }
                  _loc2_++;
               }
               this.childCanvas.height = this.childCanvas.getStyle("baseHeight");
               this.closedImage.visible = false;
               this.openImage.visible = true;
            }
            else
            {
               _loc2_ = 0;
               while(_loc2_ < this.childCanvas.numChildren)
               {
                  _loc3_ = this.childCanvas.getChildAt(_loc2_) as CheckBox;
                  if(_loc3_ != null)
                  {
                     _loc4_ = Number(_loc3_.getStyle("glowColor"));
                     _loc3_.filters = null;
                  }
                  _loc2_++;
               }
               this.childCanvas.height = 0;
               this.closedImage.visible = true;
               this.openImage.visible = false;
            }
         }
      }
      
      public function updateCheckBasedOnChildren(param1:Array) : void
      {
         var _loc4_:CheckBox = null;
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         for each(_loc4_ in param1)
         {
            if(_loc4_.selected == true)
            {
               if(!_loc2_)
               {
                  _loc2_ = true;
               }
            }
         }
         for each(_loc4_ in param1)
         {
            if(_loc4_.selected == false)
            {
               _loc3_ = true;
               break;
            }
         }
         this.checkBox.selected = _loc2_;
         if(_loc2_ && _loc3_)
         {
            this.checkBox.setStyle("iconColor",7829367);
         }
         else
         {
            this.checkBox.setStyle("iconColor",0);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.mouseChildren = true;
         this.height = 24;
         var _loc1_:Image = new Image();
         _loc1_.source = GROUP_SEPERATOR;
         _loc1_.x = 0;
         _loc1_.width = this.width;
         _loc1_.height = this.height;
         _loc1_.maintainAspectRatio = false;
         this.addChild(_loc1_);
         this.closedImage.x = this.width - 30;
         this.openImage.x = this.width - 30;
         this.closedImage.y = 4;
         this.openImage.y = 7;
         this.closedImage.visible = false;
         this.addChild(this.closedImage);
         this.addChild(this.openImage);
         this.checkBox = new CheckBox();
         this.checkBox.data = this.label;
         this.checkBox.x = 8;
         this.checkBox.setStyle("verticalCenter","0");
         this.checkBox.setStyle("iconColor","0x000000");
         this.checkBox.styleName = "endOfGameGraphCheckBox";
         this.addChild(this.checkBox);
         this.displayLabel = new Label();
         this.displayLabel.x = this.checkBox.x + this.checkBox.width;
         this.displayLabel.y = 1;
         this.displayLabel.text = this.label;
         this.displayLabel.width = this.width - this.displayLabel.x;
         this.displayLabel.height = this.height;
         this.displayLabel.setStyle("styleName","endOfGameTreeHeaderLabel");
         this.displayLabel.mouseEnabled = false;
         this.displayLabel.mouseChildren = false;
         this.addChild(this.displayLabel);
      }
   }
}

