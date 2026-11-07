package com.riotgames.landing
{
   import blix.signals.Signal;
   
   public class LandingPageNavSignals
   {
      
      public var ready:Signal = new Signal();
      
      public var jsonNavigate:Signal = new Signal();
      
      public var spectateFeaturedGame:Signal = new Signal();
      
      public function LandingPageNavSignals()
      {
         super();
      }
   }
}

