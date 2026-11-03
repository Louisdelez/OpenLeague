package com.degrafa.states
{
   public interface IOverride
   {
      
      function initialize() : void;
      
      function targetRef(param1:IDegrafaStateClient) : Object;
      
      function remove(param1:IDegrafaStateClient) : void;
      
      function apply(param1:IDegrafaStateClient) : void;
   }
}

