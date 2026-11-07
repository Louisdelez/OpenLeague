package org.swizframework.core
{
   import org.swizframework.reflection.TypeDescriptor;
   
   [DefaultProperty("source")]
   public class Bean
   {
      
      protected var _source:*;
      
      public var name:String;
      
      public var typeDescriptor:TypeDescriptor;
      
      public var beanFactory:IBeanFactory;
      
      public var initialized:Boolean = false;
      
      public function Bean(source:* = null, name:String = null, typeDescriptor:TypeDescriptor = null)
      {
         super();
         this.source = source;
         this.name = name;
         this.typeDescriptor = typeDescriptor;
      }
      
      public function get source() : *
      {
         return this._source;
      }
      
      public function set source(value:*) : void
      {
         this._source = value;
      }
      
      public function get type() : *
      {
         return this.source;
      }
      
      public function toString() : String
      {
         return "Bean{ source: " + this.source + ", name: " + this.name + " }";
      }
   }
}

