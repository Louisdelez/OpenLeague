package com.riotgames.pvpnet.docked
{
   import blix.assets.proxy.IDisplayChild;
   import blix.view.IView;
   
   public interface IFriendScroller extends IDisplayChild, IView
   {
      
      function sortByName() : void;
      
      function sortByStatus() : void;
   }
}

