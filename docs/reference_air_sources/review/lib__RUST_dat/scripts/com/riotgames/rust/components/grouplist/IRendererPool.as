package com.riotgames.rust.components.grouplist
{
   import blix.factory.IPool;
   import blix.signals.ISignal;
   import flash.geom.Rectangle;
   
   public interface IRendererPool extends IPool
   {
      
      function getRendererBounds(param1:*) : Rectangle;
      
      function getRendererBoundsChanged() : ISignal;
   }
}

