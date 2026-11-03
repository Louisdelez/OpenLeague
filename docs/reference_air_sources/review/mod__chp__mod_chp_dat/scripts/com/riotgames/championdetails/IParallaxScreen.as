package com.riotgames.championdetails
{
   import flash.geom.Point;
   
   public interface IParallaxScreen
   {
      
      function getParallaxPosition() : Point;
      
      function getParallaxDescriptors() : Vector.<ParallaxItem>;
      
      function buildUp() : void;
      
      function tearDown() : void;
   }
}

