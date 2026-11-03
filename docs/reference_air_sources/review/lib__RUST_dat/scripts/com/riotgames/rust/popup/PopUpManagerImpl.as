package com.riotgames.rust.popup
{
   import blix.IDestructible;
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.IDisplayChild;
   import blix.assets.proxy.IDisplayContainer;
   import blix.assets.proxy.InteractiveObjectProxy;
   import blix.layout.LayoutContainer;
   import blix.layout.data.CanvasLayoutData;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.ILayoutData;
   import blix.view.ILayoutElement;
   import com.riotgames.rust.focus.RiotFocusManager;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class PopUpManagerImpl implements IPopUpManager, IDestructible
   {
      
      private var _inModalModeChanged:Signal = new Signal();
      
      private var _activePopUps:Vector.<PopUpInfo> = new Vector.<PopUpInfo>();
      
      private var _displayContainer:IDisplayContainer;
      
      private var _layoutContainer:LayoutContainer;
      
      private var _totalModalPopUps:uint = 0;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(PopUpManagerImpl).replace(/::/,"."));
      
      public function PopUpManagerImpl(param1:DisplayObjectContainerProxy, param2:LayoutContainer)
      {
         super();
         this._displayContainer = param1;
         this._layoutContainer = param2;
      }
      
      public function getInModalModeChanged() : ISignal
      {
         return this._inModalModeChanged;
      }
      
      public function getInModalMode() : Boolean
      {
         return this._totalModalPopUps > 0;
      }
      
      public function addPopUp(param1:ILayoutElement, param2:ILayoutData = null, param3:Boolean = false) : void
      {
         this.logger.info("addPopUp: " + getQualifiedClassName(param1));
         if(param2 == null)
         {
            param2 = this.getDefaultLayoutData();
         }
         this._activePopUps[this._activePopUps.length] = new PopUpInfo(param1,param3);
         if(param1 is IDisplayChild)
         {
            if(param1 is InteractiveObjectProxy && RiotFocusManager.getPendingFocus() == null)
            {
               RiotFocusManager.setFocus(param1 as InteractiveObjectProxy);
            }
            this._displayContainer.addChild(param1 as IDisplayChild);
         }
         this._layoutContainer.addElement(param1,param2);
         if(param3)
         {
            ++this._totalModalPopUps;
            if(this._totalModalPopUps == 1)
            {
               this._inModalModeChanged.dispatch();
            }
         }
         this._layoutContainer.validate();
      }
      
      protected function getDefaultLayoutData() : ILayoutData
      {
         var _loc1_:CanvasLayoutData = new CanvasLayoutData();
         _loc1_.setHorizontalCenter(0);
         _loc1_.setVerticalCenter(0);
         return _loc1_;
      }
      
      public function removePopUp(param1:ILayoutElement) : Boolean
      {
         this.logger.info("removePopUp: " + getQualifiedClassName(param1));
         var _loc2_:int = this.getPopUpInfoIndex(param1);
         if(_loc2_ == -1)
         {
            return false;
         }
         var _loc3_:PopUpInfo = this._activePopUps[_loc2_];
         this._activePopUps.splice(_loc2_,1);
         if(param1 is IDisplayChild)
         {
            this._displayContainer.removeChild(param1 as IDisplayChild);
         }
         this._layoutContainer.removeElement(param1);
         if(_loc3_.isModal)
         {
            --this._totalModalPopUps;
            if(this._totalModalPopUps == 0)
            {
               this._inModalModeChanged.dispatch();
            }
         }
         return true;
      }
      
      public function removeAllPopUps() : void
      {
         var _loc1_:PopUpInfo = null;
         this.logger.info("removeAllPopUps");
         this._layoutContainer.removeAllElements();
         for each(_loc1_ in this._activePopUps)
         {
            if(_loc1_.popUp is IDisplayChild)
            {
               this._displayContainer.removeChild(_loc1_.popUp as IDisplayChild);
            }
         }
         if(this._totalModalPopUps > 0)
         {
            this._totalModalPopUps = 0;
            this._inModalModeChanged.dispatch();
         }
      }
      
      protected function getPopUpInfoIndex(param1:ILayoutElement) : int
      {
         var _loc2_:uint = this._activePopUps.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._activePopUps[_loc3_].popUp == param1)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      public function destroy() : void
      {
         this.removeAllPopUps();
         this._inModalModeChanged.removeAll();
      }
   }
}

import blix.view.ILayoutElement;

class PopUpInfo
{
   
   public var popUp:ILayoutElement;
   
   public var isModal:Boolean;
   
   public function PopUpInfo(param1:ILayoutElement, param2:Boolean)
   {
      super();
      this.popUp = param1;
      this.isModal = param2;
   }
}
