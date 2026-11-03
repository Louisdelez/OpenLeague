package org.swizframework.reflection
{
   import flash.system.ApplicationDomain;
   import flash.utils.Dictionary;
   import org.swizframework.core.SwizManager;
   import org.swizframework.factories.MetadataHostFactory;
   
   public class TypeDescriptor
   {
      
      public var domain:ApplicationDomain;
      
      public var description:XML;
      
      public var type:Class;
      
      public var className:String;
      
      public var constants:Array = [];
      
      public var superClasses:Array = [];
      
      public var interfaces:Array = [];
      
      public var metadataHosts:Dictionary;
      
      public function TypeDescriptor()
      {
         super();
      }
      
      protected function getMetadataHosts(description:XML) : Dictionary
      {
         var mdNode:XML = null;
         var metadataName:String = null;
         var args:Array = null;
         var argNode:XML = null;
         var host:IMetadataHost = null;
         var metadataTag:IMetadataTag = null;
         if(this.metadataHosts != null)
         {
            return this.metadataHosts;
         }
         this.metadataHosts = new Dictionary();
         for each(mdNode in description..metadata)
         {
            metadataName = mdNode.@name;
            if(!(metadataName.indexOf("_") == 0 || SwizManager.metadataNames.indexOf(metadataName) < 0))
            {
               args = [];
               for each(argNode in mdNode.arg)
               {
                  args.push(new MetadataArg(argNode.@key.toString(),argNode.@value.toString()));
               }
               host = this.getMetadataHost(mdNode.parent());
               metadataTag = new BaseMetadataTag();
               metadataTag.name = metadataName;
               metadataTag.args = args;
               metadataTag.host = host;
               host.metadataTags.push(metadataTag);
            }
         }
         return this.metadataHosts;
      }
      
      protected function getMetadataHost(hostNode:XML) : IMetadataHost
      {
         var metadataHostName:String = hostNode.@name.toString();
         if(this.metadataHosts[metadataHostName] != null)
         {
            return IMetadataHost(this.metadataHosts[metadataHostName]);
         }
         return this.metadataHosts[metadataHostName] = MetadataHostFactory.getMetadataHost(hostNode,this.domain);
      }
      
      public function fromXML(describeTypeXml:XML, domain:ApplicationDomain) : TypeDescriptor
      {
         var constNode:XML = null;
         var extendsNode:XML = null;
         var interfaceNode:XML = null;
         this.description = describeTypeXml;
         this.domain = domain;
         var classDescription:XML = null;
         if(this.description.factory == undefined)
         {
            classDescription = this.description;
            this.className = classDescription.@name;
         }
         else
         {
            classDescription = this.description.factory[0];
            this.className = classDescription.@type;
         }
         this.type = domain.getDefinition(this.className) as Class;
         for each(constNode in this.description.constant)
         {
            this.constants.push(new Constant(constNode.@name,this.type[constNode.@name]));
         }
         for each(extendsNode in classDescription.extendsClass)
         {
            this.superClasses.push(extendsNode.@type.toString());
         }
         for each(interfaceNode in classDescription.implementsInterface)
         {
            this.interfaces.push(interfaceNode.@type.toString());
         }
         this.metadataHosts = this.getMetadataHosts(this.description);
         return this;
      }
      
      public function hasMetadataTag(metadataTagName:String) : Boolean
      {
         var metadataHost:IMetadataHost = null;
         var metadataTag:IMetadataTag = null;
         loop0:
         for each(metadataHost in this.metadataHosts)
         {
            var _loc6_:int = 0;
            var _loc7_:* = metadataHost.metadataTags;
            do
            {
               for each(metadataTag in _loc7_)
               {
               }
               continue loop0;
            }
            while(metadataTag.name.toLowerCase() != metadataTagName.toLowerCase());
            return true;
         }
         return false;
      }
      
      public function getMetadataHostsWithTag(metadataTagName:String) : Array
      {
         var metadataHost:IMetadataHost = null;
         var metadataTag:IMetadataTag = null;
         var hosts:Array = [];
         for each(metadataHost in this.metadataHosts)
         {
            for each(metadataTag in metadataHost.metadataTags)
            {
               if(metadataTag.name.toLowerCase() == metadataTagName.toLowerCase())
               {
                  hosts.push(metadataHost);
               }
            }
         }
         return hosts;
      }
      
      public function getMetadataTagsByName(tagName:String) : Array
      {
         var metadataHost:IMetadataHost = null;
         var metadataTag:IMetadataTag = null;
         var tags:Array = [];
         for each(metadataHost in this.metadataHosts)
         {
            for each(metadataTag in metadataHost.metadataTags)
            {
               if(metadataTag.name.toLowerCase() == tagName.toLowerCase())
               {
                  tags.push(metadataTag);
               }
            }
         }
         return tags;
      }
      
      public function getMetadataTagsForMember(memberName:String) : Array
      {
         var tags:Array = null;
         var metadataHost:IMetadataHost = null;
         for each(metadataHost in this.metadataHosts)
         {
            if(metadataHost.name == memberName)
            {
               tags = metadataHost.metadataTags;
            }
         }
         return tags;
      }
      
      public function getMetadataHostProperties() : Array
      {
         var metadataHost:IMetadataHost = null;
         var hostProps:Array = [];
         for each(metadataHost in this.metadataHosts)
         {
            if(metadataHost is MetadataHostProperty)
            {
               hostProps.push(metadataHost);
            }
         }
         return hostProps;
      }
      
      public function getMetadataHostMethods() : Array
      {
         var metadataHost:IMetadataHost = null;
         var hostMethods:Array = [];
         for each(metadataHost in this.metadataHosts)
         {
            if(metadataHost is MetadataHostMethod)
            {
               hostMethods.push(metadataHost);
            }
         }
         return hostMethods;
      }
      
      public function satisfiesType(typeName:String) : Boolean
      {
         var superClass:String = null;
         var interfaceName:String = null;
         if(this.className == typeName)
         {
            return true;
         }
         for each(superClass in this.superClasses)
         {
            if(superClass == typeName)
            {
               return true;
            }
         }
         for each(interfaceName in this.interfaces)
         {
            if(interfaceName == typeName)
            {
               return true;
            }
         }
         return false;
      }
   }
}

