package org.swizframework.factories
{
   import flash.system.ApplicationDomain;
   import org.swizframework.reflection.IMetadataHost;
   import org.swizframework.reflection.MetadataHostClass;
   import org.swizframework.reflection.MetadataHostMethod;
   import org.swizframework.reflection.MetadataHostProperty;
   import org.swizframework.reflection.MethodParameter;
   
   public class MetadataHostFactory
   {
      
      public function MetadataHostFactory()
      {
         super();
      }
      
      public static function getMetadataHost(hostNode:XML, domain:ApplicationDomain) : IMetadataHost
      {
         var host:IMetadataHost = null;
         var pNode:XML = null;
         var pType:Class = null;
         var hostKind:String = hostNode.name();
         if(hostKind == "type" || hostKind == "factory")
         {
            host = new MetadataHostClass();
            if(hostKind == "type")
            {
               host.type = domain.getDefinition(hostNode.@name.toString()) as Class;
            }
            else
            {
               host.type = domain.getDefinition(hostNode.@type.toString()) as Class;
            }
         }
         else if(hostKind == "method")
         {
            host = new MetadataHostMethod();
            if(hostNode.@returnType != "void" && hostNode.@returnType != "*")
            {
               MetadataHostMethod(host).returnType = Class(domain.getDefinition(hostNode.@returnType));
            }
            for each(pNode in hostNode.parameter)
            {
               pType = pNode.@type == "*" ? Object : Class(domain.getDefinition(pNode.@type));
               MetadataHostMethod(host).parameters.push(new MethodParameter(int(pNode.@index),pType,pNode.@optional == "true"));
            }
         }
         else
         {
            host = new MetadataHostProperty();
            host.type = hostNode.@type == "*" ? Object : Class(domain.getDefinition(hostNode.@type));
         }
         host.name = hostNode.@uri == undefined ? String(hostNode.@name[0]) : new QName(hostNode.@uri,hostNode.@name);
         return host;
      }
   }
}

