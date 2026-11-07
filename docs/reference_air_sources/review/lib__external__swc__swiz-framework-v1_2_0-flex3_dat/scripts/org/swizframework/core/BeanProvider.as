package org.swizframework.core
{
   import flash.events.EventDispatcher;
   import flash.system.ApplicationDomain;
   import flash.utils.describeType;
   
   [DefaultProperty("beans")]
   public class BeanProvider extends EventDispatcher implements IBeanProvider
   {
      
      protected var _rawBeans:Array = [];
      
      protected var _beans:Array = [];
      
      public function BeanProvider(beans:Array = null)
      {
         super();
         this.beans = beans;
      }
      
      [ArrayElementType("Object")]
      public function get beans() : Array
      {
         return this._beans;
      }
      
      public function set beans(value:Array) : void
      {
         if(value != null && value != this._beans && value != this._rawBeans)
         {
            this._rawBeans = value;
         }
      }
      
      public function initialize(domain:ApplicationDomain) : void
      {
         this.initializeBeans(domain);
         this.setBeanIds(domain);
      }
      
      public function addBean(bean:Bean) : void
      {
         if(Boolean(this.beans))
         {
            this.beans[this.beans.length] = bean;
         }
         else
         {
            this.beans = [bean];
         }
      }
      
      public function removeBean(bean:Bean) : void
      {
         if(Boolean(this.beans))
         {
            this.beans.splice(this.beans.indexOf(bean),1);
         }
      }
      
      protected function initializeBeans(domain:ApplicationDomain) : void
      {
         var beanSource:Object = null;
         for each(beanSource in this._rawBeans)
         {
            this._beans.push(BeanFactory.constructBean(beanSource,null,domain));
         }
      }
      
      protected function setBeanIds(domain:ApplicationDomain) : void
      {
         var xmlDescription:XML = null;
         var beanList:XMLList = null;
         var child:* = undefined;
         var name:String = null;
         var beanId:String = null;
         var found:Boolean = false;
         var node:XML = null;
         var bean:Bean = null;
         xmlDescription = describeType(this);
         beanList = xmlDescription.*.((localName() == "variable" || localName() == "accessor" && @access == "readwrite") && attribute("uri") == undefined);
         for each(node in beanList)
         {
            name = node.@name;
            beanId = node.localName() == "accessor" ? name : null;
            if(name != "beans")
            {
               child = this[name];
               if(child != null)
               {
                  found = false;
                  for each(bean in this.beans)
                  {
                     if(bean == child || bean.type == child)
                     {
                        bean.name = beanId;
                        found = true;
                        break;
                     }
                  }
                  if(!found)
                  {
                     this.beans.push(BeanFactory.constructBean(child,beanId,domain));
                  }
               }
            }
         }
      }
   }
}

