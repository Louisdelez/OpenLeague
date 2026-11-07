package org.swizframework.processors
{
   import flash.utils.Dictionary;
   import mx.binding.utils.BindingUtils;
   import mx.binding.utils.ChangeWatcher;
   import mx.utils.UIDUtil;
   import org.swizframework.core.Bean;
   import org.swizframework.core.ISwizAware;
   import org.swizframework.metadata.InjectMetadataTag;
   import org.swizframework.reflection.IMetadataTag;
   import org.swizframework.reflection.MetadataHostClass;
   import org.swizframework.reflection.MetadataHostMethod;
   import org.swizframework.reflection.MethodParameter;
   import org.swizframework.utils.logging.SwizLogger;
   import org.swizframework.utils.services.IServiceHelper;
   import org.swizframework.utils.services.IURLRequestHelper;
   import org.swizframework.utils.services.MockDelegateHelper;
   import org.swizframework.utils.services.ServiceHelper;
   import org.swizframework.utils.services.URLRequestHelper;
   
   public class InjectProcessor extends BaseMetadataProcessor
   {
      
      protected static const INJECT:String = "Inject";
      
      protected static const AUTOWIRE:String = "Autowire";
      
      protected var logger:SwizLogger = SwizLogger.getLogger(this);
      
      protected var injectByProperty:Dictionary = new Dictionary();
      
      protected var sharedServiceHelper:IServiceHelper;
      
      protected var sharedURLRequestHelper:IURLRequestHelper;
      
      protected var sharedMockDelegateHelper:MockDelegateHelper;
      
      public function InjectProcessor(metadataNames:Array = null)
      {
         super(metadataNames == null ? [INJECT,AUTOWIRE] : metadataNames,InjectMetadataTag);
      }
      
      override public function get priority() : int
      {
         return ProcessorPriority.INJECT;
      }
      
      override public function setUpMetadataTag(metadataTag:IMetadataTag, bean:Bean) : void
      {
         var namedBean:Bean = null;
         var destObject:Object = null;
         var destPropName:* = undefined;
         var chain:String = null;
         var bind:Boolean = false;
         var sourceObject:Object = null;
         var errorStr:String = null;
         var injectTag:InjectMetadataTag = metadataTag as InjectMetadataTag;
         if(injectTag.name == AUTOWIRE)
         {
            this.logger.warn("[Autowire] has been deprecated in favor of [Inject]. Please update {0} accordingly.",bean);
         }
         if(injectTag.source == null)
         {
            this.addInjectByType(injectTag,bean);
         }
         else
         {
            namedBean = this.getBeanByName(injectTag.source.split(".")[0]);
            if(namedBean == null)
            {
               if(injectTag.required)
               {
                  throw new Error("InjectionProcessorError: bean not found: " + injectTag.source);
               }
               this.logger.warn("InjectProcessor could not fulfill {0} tag on {1}",injectTag.asTag,bean);
               return;
            }
            destObject = injectTag.destination == null ? bean.source : this.getDestinationObject(bean.source,injectTag.destination);
            destPropName = this.getDestinationPropertyName(injectTag);
            chain = injectTag.source.substr(injectTag.source.indexOf(".") + 1);
            bind = injectTag.bind && Boolean(ChangeWatcher.canWatch(namedBean.source,chain)) && !(destPropName is QName);
            if(injectTag.source.indexOf(".") < 0)
            {
               this.setDestinationValue(injectTag,bean,namedBean.source);
            }
            else if(!bind)
            {
               sourceObject = this.getDestinationObject(namedBean.source,chain);
               this.setDestinationValue(injectTag,bean,sourceObject[injectTag.source.split(".").pop()]);
               if(destPropName is QName && injectTag.bind == true)
               {
                  errorStr = "Cannot create a binding for " + metadataTag.asTag + " because " + injectTag.source.split(".").pop() + " is not public. ";
                  errorStr += "Add bind=false to your Inject tag or make the property public.";
                  throw new Error(errorStr);
               }
            }
            else
            {
               this.addPropertyBinding(destObject,destPropName,namedBean.source,injectTag.source.split(".").slice(1),injectTag.twoWay);
            }
         }
         this.logger.debug("InjectProcessor set up {0} on {1}",metadataTag.toString(),bean.toString());
      }
      
      override public function tearDownMetadataTag(metadataTag:IMetadataTag, bean:Bean) : void
      {
         var injectTag:InjectMetadataTag = metadataTag as InjectMetadataTag;
         if(injectTag.source != null)
         {
            if(injectTag.source.indexOf(".") > -1)
            {
               this.removeInjectByProperty(injectTag,bean);
            }
            else
            {
               this.removeInjectByName(injectTag,bean);
            }
         }
         else
         {
            this.removeInjectByType(injectTag,bean);
         }
         this.logger.debug("InjectProcessor tore down {0} on {1}",metadataTag.toString(),bean.toString());
      }
      
      protected function getDestinationObject(destObject:Object, chainString:String) : Object
      {
         var arr:Array = chainString.split(".");
         var dest:Object = destObject;
         while(arr.length > 1)
         {
            dest = dest[arr.shift()];
         }
         return dest;
      }
      
      protected function getDestinationPropertyName(injectTag:InjectMetadataTag) : *
      {
         if(injectTag.destination == null)
         {
            return injectTag.host.name;
         }
         return injectTag.destination.split(".").pop();
      }
      
      protected function removeInjectByProperty(injectTag:InjectMetadataTag, bean:Bean) : void
      {
         var namedBean:Bean = this.getBeanByName(injectTag.source.split(".")[0]);
         this.removePropertyBinding(bean,namedBean,injectTag);
         this.setDestinationValue(injectTag,bean,null);
      }
      
      protected function removeInjectByName(injectTag:InjectMetadataTag, bean:Bean) : void
      {
         this.setDestinationValue(injectTag,bean,null);
      }
      
      protected function addInjectByType(injectTag:InjectMetadataTag, bean:Bean) : void
      {
         var setterInjection:Boolean = injectTag.host is MetadataHostMethod;
         var targetType:Class = setterInjection ? MethodParameter(MetadataHostMethod(injectTag.host).parameters[0]).type : injectTag.host.type;
         if(targetType == null && injectTag.host is MetadataHostClass)
         {
            targetType = swiz.domain.getDefinition(injectTag.host.name) as Class;
         }
         var typedBean:Bean = this.getBeanByType(targetType);
         if(Boolean(typedBean))
         {
            this.setDestinationValue(injectTag,bean,typedBean.source);
         }
         else
         {
            switch(targetType)
            {
               case ServiceHelper:
               case IServiceHelper:
                  if(this.sharedServiceHelper == null)
                  {
                     this.sharedServiceHelper = new ServiceHelper();
                     ISwizAware(this.sharedServiceHelper).swiz = swiz;
                  }
                  this.setDestinationValue(injectTag,bean,this.sharedServiceHelper);
                  return;
               case URLRequestHelper:
               case IURLRequestHelper:
                  if(this.sharedURLRequestHelper == null)
                  {
                     this.sharedURLRequestHelper = new URLRequestHelper();
                     ISwizAware(this.sharedURLRequestHelper).swiz = swiz;
                  }
                  this.setDestinationValue(injectTag,bean,this.sharedURLRequestHelper);
                  return;
               case MockDelegateHelper:
                  if(this.sharedMockDelegateHelper == null)
                  {
                     this.sharedMockDelegateHelper = new MockDelegateHelper();
                  }
                  this.setDestinationValue(injectTag,bean,this.sharedMockDelegateHelper);
                  return;
               default:
                  if(injectTag.required)
                  {
                     throw new Error("InjectProcessor Error: bean of type " + targetType.toString() + " not found!");
                  }
                  this.logger.warn("Bean of type {0} not found, injection queues have been removed!",targetType.toString());
            }
         }
      }
      
      protected function removeInjectByType(injectTag:InjectMetadataTag, bean:Bean) : void
      {
         this.setDestinationValue(injectTag,bean,null);
      }
      
      protected function setDestinationValue(injectTag:InjectMetadataTag, bean:Bean, value:*) : void
      {
         var f:Function = null;
         var setterInjection:Boolean = injectTag.host is MetadataHostMethod;
         var destObject:Object = injectTag.destination == null ? bean.source : this.getDestinationObject(bean.source,injectTag.destination);
         var destPropName:* = this.getDestinationPropertyName(injectTag);
         if(setterInjection)
         {
            f = destObject[destPropName] as Function;
            f.apply(destObject,[value]);
         }
         else
         {
            destObject[destPropName] = value;
         }
      }
      
      protected function getBeanByName(name:String) : Bean
      {
         return beanFactory.getBeanByName(name);
      }
      
      protected function getBeanByType(type:Class) : Bean
      {
         return beanFactory.getBeanByType(type);
      }
      
      protected function addPropertyBinding(destObject:Object, destPropName:String, sourceObject:Object, sourcePropertyChain:Array, twoWay:Boolean = false) : void
      {
         var cw:ChangeWatcher = null;
         var uid:String = null;
         var sourcePropName:String = null;
         uid = UIDUtil.getUID(destObject);
         this.injectByProperty[uid] = this.injectByProperty[uid] || [];
         try
         {
            if(destObject[destPropName] is Function)
            {
               this.injectByProperty[uid].push(BindingUtils.bindSetter(destObject[destPropName],sourceObject,sourcePropertyChain));
            }
            else
            {
               this.injectByProperty[uid].push(BindingUtils.bindProperty(destObject,destPropName,sourceObject,sourcePropertyChain));
            }
         }
         catch(error:ReferenceError)
         {
            injectByProperty[uid].push(BindingUtils.bindProperty(destObject,destPropName,sourceObject,sourcePropertyChain));
            if(twoWay)
            {
               logger.error("Cannot create twoWay binding for {0} property on {1} because it is write-only.",destPropName,destObject);
               return;
            }
         }
         if(twoWay)
         {
            if(destObject[destPropName] is Function)
            {
               this.logger.error("Cannot create twoWay binding for {0} method on {1} because methods cannot be binding sources.",destPropName,destObject);
               return;
            }
            while(sourcePropertyChain.length > 1)
            {
               sourceObject = sourceObject[sourcePropertyChain.shift()];
            }
            sourcePropName = sourcePropertyChain[0];
            if(ChangeWatcher.canWatch(destObject,destPropName))
            {
               this.injectByProperty[uid].push(BindingUtils.bindProperty(sourceObject,sourcePropName,destObject,destPropName));
            }
            else
            {
               this.logger.error("Cannot create twoWay binding for {0} property on {1} because it is not bindable.",destPropName,destObject);
            }
         }
      }
      
      protected function removePropertyBinding(destination:Bean, source:Bean, injectTag:InjectMetadataTag) : void
      {
         var cw:ChangeWatcher = null;
         var destObject:Object = injectTag.destination == null ? destination.source : this.getDestinationObject(destination.source,injectTag.destination);
         var uid:String = UIDUtil.getUID(destObject);
         for each(cw in this.injectByProperty[uid])
         {
            cw.unwatch();
         }
         delete this.injectByProperty[uid];
      }
   }
}

