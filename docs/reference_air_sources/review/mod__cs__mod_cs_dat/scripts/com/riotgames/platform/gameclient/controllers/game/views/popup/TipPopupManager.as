package com.riotgames.platform.gameclient.controllers.game.views.popup
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import mx.core.UIComponent;
   import mx.managers.PopUpManager;
   
   public class TipPopupManager implements ITipPopupManager
   {
      
      public static const TOOLTIP_NEWBIE:String = "newbie";
      
      public static const TOOLTIP_RANKED:String = "ranked";
      
      private var currentPopups:Vector.<UIComponent> = new Vector.<UIComponent>();
      
      private var allowedTypes:Object = {
         "newbie":TipPopup,
         "ranked":TipPopupRanked
      };
      
      public function TipPopupManager()
      {
         super();
      }
      
      private function onMouseUp(param1:MouseEvent, param2:TipPopup) : void
      {
         param2.stopDrag();
      }
      
      public function removePopup(param1:*) : void
      {
         if(this.currentPopups.length > 0)
         {
            param1.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            param1.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
            PopUpManager.removePopUp(param1);
         }
      }
      
      public function removeAllPopups() : void
      {
         var _loc1_:TipPopup = null;
         for each(_loc1_ in this.currentPopups)
         {
            _loc1_.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            _loc1_.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
            PopUpManager.removePopUp(_loc1_);
            this.currentPopups = new Vector.<UIComponent>();
         }
      }
      
      public function createTipPopup(param1:DisplayObject, param2:String, param3:String, param4:String, param5:Number = -1, param6:Number = -1, param7:Number = -1, param8:Number = -1) : void
      {
         var newPopup:TipPopup = null;
         var parent:DisplayObject = param1;
         var type:String = param2;
         var header:String = param3;
         var tip:String = param4;
         var x:Number = param5;
         var y:Number = param6;
         var width:Number = param7;
         var height:Number = param8;
         if(!this.isAllowedType(type))
         {
            trace("Disallowed tip type");
            return;
         }
         if(type == TOOLTIP_NEWBIE)
         {
            this.removeLastNewbiePopups();
         }
         newPopup = new this.allowedTypes[type]();
         newPopup.header = header;
         newPopup.tip = tip;
         if(width > 0)
         {
            newPopup.explicitWidth = width;
         }
         if(height > 0)
         {
            newPopup.explicitHeight = height;
         }
         PopUpManager.addPopUp(newPopup,parent);
         PopUpManager.bringToFront(newPopup);
         if(x > -1 && y > -1)
         {
            newPopup.move(x,y);
         }
         else if(x > -1)
         {
            PopUpManager.centerPopUp(newPopup);
            newPopup.move(x,newPopup.y);
         }
         else if(y > -1)
         {
            PopUpManager.centerPopUp(newPopup);
            newPopup.move(newPopup.x,y);
         }
         newPopup.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            onMouseDown(param1,newPopup);
         });
         newPopup.addEventListener(MouseEvent.MOUSE_UP,function(param1:MouseEvent):void
         {
            onMouseUp(param1,newPopup);
         });
         newPopup.addEventListener(Event.CLOSE,function(param1:Event):void
         {
            onTipPopupClosed(param1,newPopup);
         });
         this.currentPopups.push(newPopup);
      }
      
      private function onMouseDown(param1:MouseEvent, param2:TipPopup) : void
      {
         param2.startDrag();
      }
      
      private function isAllowedType(param1:String) : Boolean
      {
         if(this.allowedTypes[param1] != null)
         {
            return true;
         }
         return false;
      }
      
      private function onTipPopupClosed(param1:Event, param2:TipPopup) : void
      {
         this.removePopup(param2);
      }
      
      public function removeLastNewbiePopups() : void
      {
         var _loc1_:TipPopup = null;
         for each(_loc1_ in this.currentPopups)
         {
            if(_loc1_.tipType == TOOLTIP_NEWBIE)
            {
               this.removePopup(_loc1_);
            }
         }
      }
   }
}

