package com.riotgames.pvpnet.chat
{
   import blix.assets.proxy.IDisplayChild;
   import blix.components.renderer.IDataRenderer;
   import blix.signals.ISignal;
   import blix.view.IView;
   import flash.geom.Rectangle;
   
   public interface IDockedMessageWindow extends IDataRenderer, IView, IDisplayChild
   {
      
      function getCloseWindowRequested() : ISignal;
      
      function getMinimizeWindowRequested() : ISignal;
      
      function getViewProfileRequested() : ISignal;
      
      function getIsOpen() : Boolean;
      
      function setIsOpen(param1:Boolean) : void;
      
      function getActivateWindowRequested() : ISignal;
      
      function setAvailableSpace(param1:Rectangle) : void;
   }
}

