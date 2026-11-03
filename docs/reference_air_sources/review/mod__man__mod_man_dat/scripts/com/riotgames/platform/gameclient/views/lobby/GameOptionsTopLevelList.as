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
   import mx.collections.ArrayCollection;
   import mx.controls.List;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.events.ListEvent;
   import mx.events.ListEventReason;
   import mx.events.SandboxMouseEvent;
   import mx.styles.*;
   
   public class GameOptionsTopLevelList extends List
   {
      
      public var onSelectItemCallback:Function;
      
      private var _lastSelected:int = -1;
      
      private var mouseDownItem:IListItemRenderer;
      
      private var _updateNeeded:Boolean = false;
      
      public function GameOptionsTopLevelList()
      {
         super();
         if(!this.styleDeclaration)
         {
            this.styleDeclaration = new CSSStyleDeclaration();
         }
         this.styleDeclaration.defaultFactory = function():void
         {
            this.paddingLeft = 0;
            this.paddingTop = -3;
         };
         this.verticalScrollPolicy = "off";
         this.allowDragSelection = false;
         this.variableRowHeight = true;
         this.dragMoveEnabled = false;
         this.dropEnabled = false;
         this.tabEnabled = false;
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
         if(!enabled || !selectable || !_loc2_.data.enabled)
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
         this.drawItem(_loc5_,isItemSelected(_loc5_.data),false,false);
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
         var _loc9_:ListEvent = null;
         var _loc10_:Point = null;
         _loc3_ = mouseEventToItemRenderer(param1);
         var _loc7_:IListItemRenderer = mouseEventToItemRenderer(param1);
         var _loc8_:Point = itemRendererToIndices(_loc7_);
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
            _loc7_ = this.mouseDownItem;
            this.mouseDownItem = null;
            this.drawItem(_loc7_,isItemSelected(_loc7_.data),false,false);
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
      
      private function onRenderEnabledChanged(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(this.selectedItem == param1.target.data)
         {
            _loc2_ = 0;
            while(_loc2_ < this.rowCount)
            {
               if(this.selectedIndex != _loc2_)
               {
                  this.selectedIndex = _loc2_;
                  this._updateNeeded = true;
               }
               _loc2_++;
            }
         }
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      override public function createItemRenderer(param1:Object) : IListItemRenderer
      {
         var _loc2_:ChooseGameOptionsTopLevelRenderer = super.createItemRenderer(param1) as ChooseGameOptionsTopLevelRenderer;
         _loc2_.index = (this.dataProvider as ArrayCollection).getItemIndex(param1);
         _loc2_.currentState = ChooseGameOptionsTopLevelRenderer.UP;
         _loc2_.addEventListener(ChooseGameOptionsTopLevelRenderer.ENABLED_CHANGE_EVENT,this.onRenderEnabledChanged,false,0,true);
         return _loc2_;
      }
      
      private function mouseLeaveHandler(param1:Event) : void
      {
      }
      
      override protected function drawItem(param1:IListItemRenderer, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false) : void
      {
         if(!param1)
         {
            return;
         }
         super.drawItem(param1,param2,param3,param4,param5);
         var _loc6_:ChooseGameOptionsTopLevelRenderer = param1 as ChooseGameOptionsTopLevelRenderer;
         _loc6_.offsetY(-4 * _loc6_.index);
         if(param2 && Boolean(_loc6_.data.enabled))
         {
            _loc6_.currentState = ChooseGameOptionsTopLevelRenderer.SELECTED;
         }
         else if(param3 && Boolean(_loc6_.data.enabled))
         {
            _loc6_.currentState = ChooseGameOptionsTopLevelRenderer.OVER;
         }
         else if(Boolean(this.mouseDownItem) && this.mouseDownItem === _loc6_)
         {
            _loc6_.currentState = ChooseGameOptionsTopLevelRenderer.DOWN;
         }
         else
         {
            _loc6_.currentState = ChooseGameOptionsTopLevelRenderer.UP;
         }
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

