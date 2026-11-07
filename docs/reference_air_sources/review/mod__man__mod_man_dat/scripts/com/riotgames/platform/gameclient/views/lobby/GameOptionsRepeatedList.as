package com.riotgames.platform.gameclient.views.lobby
{
   import flash.accessibility.*;
   import flash.data.*;
   import flash.debugger.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filesystem.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.html.*;
   import flash.html.script.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import mx.binding.*;
   import mx.controls.List;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.events.ListEvent;
   import mx.events.ListEventReason;
   import mx.events.SandboxMouseEvent;
   import mx.styles.*;
   
   public class GameOptionsRepeatedList extends List
   {
      
      public var onSelectItemCallback:Function;
      
      private var _lastSelected:int = -1;
      
      private var mouseDownItem:IListItemRenderer;
      
      private var _updateNeeded:Boolean = false;
      
      public function GameOptionsRepeatedList()
      {
         super();
         if(!this.styleDeclaration)
         {
            this.styleDeclaration = new CSSStyleDeclaration();
         }
         this.styleDeclaration.defaultFactory = function():void
         {
            this.paddingLeft = 1;
            this.paddingTop = 1;
            this.paddingBottom = 1;
         };
         this.styleName = "optionsFlowList";
         this.allowMultipleSelection = false;
         this.allowDragSelection = true;
         this.tabEnabled = false;
         this.doubleClickEnabled = true;
         this.addEventListener("change",this.___GameOptionsRepeatedList_List1_change);
      }
      
      override protected function mouseDownHandler(param1:MouseEvent) : void
      {
         var _loc2_:IListItemRenderer = null;
         var _loc3_:Sprite = null;
         var _loc6_:Point = null;
         var _loc7_:Boolean = false;
         _loc2_ = mouseEventToItemRenderer(param1);
         var _loc4_:Boolean = Boolean(itemRendererContains(itemEditorInstance,DisplayObject(param1.target)));
         if(!_loc4_)
         {
            if(Boolean(_loc2_) && Boolean(_loc2_.data))
            {
               _loc6_ = itemRendererToIndices(_loc2_);
               _loc7_ = true;
               if(itemEditorInstance)
               {
                  _loc7_ = Boolean(endEdit(ListEventReason.NEW_ROW));
               }
               if(!_loc7_)
               {
                  return;
               }
            }
            else if(itemEditorInstance)
            {
               endEdit(ListEventReason.OTHER);
            }
         }
         if(!enabled || !selectable)
         {
            return;
         }
         if(runningDataEffect)
         {
            cachedItemsChangeEffect.end();
            dataEffectCompleted = true;
            itemsSizeChanged = true;
            invalidateList();
            dataItemWrappersByRenderer = new Dictionary();
            validateDisplayList();
         }
         var _loc5_:IListItemRenderer = mouseEventToItemRenderer(param1);
         if(!_loc5_)
         {
            return;
         }
         systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler,true,0,true);
         this.mouseDownItem = _loc5_;
      }
      
      override protected function drawSelectionIndicator(param1:Sprite, param2:Number, param3:Number, param4:Number, param5:Number, param6:uint, param7:IListItemRenderer) : void
      {
      }
      
      override protected function dragScroll() : void
      {
      }
      
      override protected function keyDownHandler(param1:KeyboardEvent) : void
      {
      }
      
      override protected function mouseUpHandler(param1:MouseEvent) : void
      {
         var _loc2_:ListEvent = null;
         var _loc3_:IListItemRenderer = null;
         var _loc4_:Sprite = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc8_:Point = null;
         var _loc9_:ListEvent = null;
         var _loc10_:Point = null;
         _loc3_ = mouseEventToItemRenderer(param1);
         var _loc7_:IListItemRenderer = mouseEventToItemRenderer(param1);
         systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler,true);
         systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.mouseLeaveHandler);
         if(!enabled || !selectable)
         {
            return;
         }
         if(Boolean(this.mouseDownItem) && Boolean(this.mouseDownItem === _loc7_) && Boolean(selectItem(_loc7_,param1.shiftKey,param1.ctrlKey)))
         {
            this._updateNeeded = true;
            this.callLater(this.onSelectItemCallback,[_loc7_]);
            _loc9_ = new ListEvent(ListEvent.CHANGE);
            _loc9_.itemRenderer = this.mouseDownItem;
            _loc8_ = itemRendererToIndices(this.mouseDownItem);
            if(_loc8_)
            {
               _loc9_.columnIndex = _loc8_.x;
               _loc9_.rowIndex = _loc8_.y;
            }
            dispatchEvent(_loc9_);
            this.mouseDownItem = null;
         }
         else if(this.mouseDownItem)
         {
            this.drawItem(this.mouseDownItem,isItemSelected(this.mouseDownItem.data),false,false);
         }
         if(!_loc7_ || !hitTestPoint(param1.stageX,param1.stageY))
         {
            return;
         }
         if(Boolean(_loc3_) && Boolean(_loc3_.data) && _loc3_ != itemEditorInstance)
         {
            _loc10_ = itemRendererToIndices(_loc3_);
            if(editable)
            {
               _loc2_ = new ListEvent(ListEvent.ITEM_EDIT_BEGINNING,false,true);
               _loc2_.rowIndex = _loc10_.y;
               _loc2_.columnIndex = 0;
               _loc2_.itemRenderer = _loc3_;
               dispatchEvent(_loc2_);
            }
         }
      }
      
      override protected function drawHighlightIndicator(param1:Sprite, param2:Number, param3:Number, param4:Number, param5:Number, param6:uint, param7:IListItemRenderer) : void
      {
      }
      
      private function onChange(param1:ListEvent) : void
      {
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      public function ___GameOptionsRepeatedList_List1_change(param1:ListEvent) : void
      {
         this.onChange(param1);
      }
      
      private function mouseLeaveHandler(param1:Event) : void
      {
      }
      
      override protected function drawItem(param1:IListItemRenderer, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false) : void
      {
         super.drawItem(param1,param2,param3,param4,param5);
         var _loc6_:ChooseGameOptionsRepeatedRenderer = param1 as ChooseGameOptionsRepeatedRenderer;
         if(_loc6_)
         {
            if(param2)
            {
               _loc6_.currentState = ChooseGameOptionsRepeatedRenderer.SELECTED;
            }
            else if(param3)
            {
               _loc6_.currentState = ChooseGameOptionsRepeatedRenderer.OVER;
            }
            else
            {
               _loc6_.currentState = ChooseGameOptionsRepeatedRenderer.UP;
            }
            _loc6_.redraw();
         }
         this.height = this.measureHeightOfItems();
         if(this.height < this.minHeight)
         {
            this.height = this.minHeight;
         }
      }
      
      override protected function mouseMoveHandler(param1:MouseEvent) : void
      {
         super.mouseMoveHandler(param1);
      }
      
      public function get updateNeeded() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this._updateNeeded)
         {
            _loc1_ = true;
            this._updateNeeded = false;
         }
         return _loc1_;
      }
   }
}

