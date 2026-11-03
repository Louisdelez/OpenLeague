package org.swizframework.events
{
   import flash.events.Event;
   
   public class BeanEvent extends Event
   {
      
      public static const ADD_BEAN:String = "addBean";
      
      public static const SET_UP_BEAN:String = "setUpBean";
      
      public static const TEAR_DOWN_BEAN:String = "tearDownBean";
      
      public static const REMOVE_BEAN:String = "removeBean";
      
      public var source:*;
      
      public var beanName:String;
      
      public function BeanEvent(type:String, source:* = null, beanName:String = null)
      {
         super(type,true,true);
         this.source = source;
         this.beanName = beanName;
      }
      
      override public function clone() : Event
      {
         return new BeanEvent(type,this.source);
      }
   }
}

