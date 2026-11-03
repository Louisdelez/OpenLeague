package com.riotgames.pvpnet.invite.views
{
   import blix.IDestructible;
   import blix.assets.proxy.IDisplayChild;
   import blix.signals.ISignal;
   import blix.view.IView;
   
   public interface IInviteView extends IView, IDisplayChild, IDestructible
   {
      
      function getSuggestRequested() : ISignal;
      
      function getClose() : ISignal;
      
      function hide() : void;
      
      function show() : void;
      
      function getInviteRequested() : ISignal;
   }
}

