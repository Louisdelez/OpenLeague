package org.swizframework.utils.test
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import org.swizframework.core.Bean;
   import org.swizframework.core.Swiz;
   import org.swizframework.core.SwizConfig;
   import org.swizframework.reflection.TypeCache;
   
   public class AutowiredTestCase extends EventDispatcher
   {
      
      private var _beanProviders:Array;
      
      private var _swizConfig:SwizConfig;
      
      private var _swiz:Swiz;
      
      public function AutowiredTestCase(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public function set beanProviders(beanProviders:Array) : void
      {
         this._beanProviders = beanProviders;
      }
      
      public function get beanProviders() : Array
      {
         return this._beanProviders;
      }
      
      public function set swizConfig(swizConfig:SwizConfig) : void
      {
         this._swizConfig = swizConfig;
      }
      
      public function get swizConfig() : SwizConfig
      {
         return this._swizConfig;
      }
      
      public function get swiz() : Swiz
      {
         return this._swiz;
      }
      
      [Before]
      public function constructSwizContext() : void
      {
         var bean:Bean = null;
         trace("constructSwizContext() called");
         if(this._swiz == null && this._beanProviders != null)
         {
            this._swiz = new Swiz(null,this._swizConfig,null,this._beanProviders);
            this._swiz.init();
            bean = new Bean();
            bean.source = this;
            bean.typeDescriptor = TypeCache.getTypeDescriptor(bean.type,this._swiz.domain);
            this._swiz.beanFactory.setUpBean(bean);
         }
      }
   }
}

