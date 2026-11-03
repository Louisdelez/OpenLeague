package com.degrafa.states
{
   import com.degrafa.IGeometry;
   import com.degrafa.core.collections.GeometryCollection;
   import flash.events.IEventDispatcher;
   
   public interface IDegrafaStateClient extends IEventDispatcher, IStateClient, IGeometry
   {
      
      function get geometryCollection() : GeometryCollection;
      
      function get states() : Array;
      
      function set geometry(param1:Array) : void;
      
      function get geometry() : Array;
      
      function get isInitialized() : Boolean;
      
      function set states(param1:Array) : void;
   }
}

