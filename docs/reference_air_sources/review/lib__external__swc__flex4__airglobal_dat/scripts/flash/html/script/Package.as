package flash.html.script
{
   import flash.system.ApplicationDomain;
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   
   use namespace flash_proxy;
   
   [API("661")]
   [native(cls="HTMLScriptPackageClass",instance="HTMLScriptProxy::HTMLScriptPackageObject",methods="auto",construct="native")]
   public final class Package extends Proxy
   {
      
      private var m_parent:Package;
      
      private var m_packageName:String;
      
      private var m_fullyQualifiedName:String;
      
      private var m_appDomain:ApplicationDomain;
      
      public function Package(parent:Package, packageName:String, appDomain:ApplicationDomain)
      {
         super();
         if(parent != null)
         {
            if(packageName == null)
            {
               throw new ArgumentError("Only the root package may have null name.");
            }
         }
         this.m_parent = parent;
         if(parent == null)
         {
            this.m_packageName = null;
         }
         else
         {
            this.m_packageName = packageName;
         }
         this.m_fullyQualifiedName = null;
         this.m_appDomain = appDomain;
      }
      
      private static native function nativeConstruct(param1:Package, param2:String, param3:ApplicationDomain) : Package;
      
      private function getFullyQualifiedPackageName() : String
      {
         var parentFQName:String = null;
         if(this.m_parent != null)
         {
            if(this.m_fullyQualifiedName == null)
            {
               parentFQName = this.m_parent.getFullyQualifiedPackageName();
               if(parentFQName != null)
               {
                  this.m_fullyQualifiedName = parentFQName + "." + this.m_packageName;
               }
               else
               {
                  this.m_fullyQualifiedName = this.m_packageName;
               }
            }
         }
         return this.m_fullyQualifiedName;
      }
      
      final override flash_proxy function hasProperty(name:*) : Boolean
      {
         return true;
      }
      
      private function getFullyQualifiedName(nameAsString:String) : String
      {
         var fullyQualifiedName:String = null;
         var fqPackageName:String = this.getFullyQualifiedPackageName();
         if(fqPackageName != null)
         {
            fullyQualifiedName = this.getFullyQualifiedPackageName() + "." + nameAsString;
         }
         else
         {
            fullyQualifiedName = nameAsString;
         }
         return fullyQualifiedName;
      }
      
      private function doLookup(nameAsString:String) : *
      {
         var fullyQualifiedName:String = this.getFullyQualifiedName(nameAsString);
         var result:* = null;
         try
         {
            result = this.m_appDomain.getDefinition(fullyQualifiedName);
         }
         catch(refError:ReferenceError)
         {
            result = null;
         }
         return result;
      }
      
      final override flash_proxy function getProperty(name:*) : *
      {
         var nameAsString:String = String(name);
         var result:* = this.doLookup(nameAsString);
         if(result == null)
         {
            result = nativeConstruct(this,nameAsString,this.m_appDomain);
         }
         return result;
      }
      
      final override flash_proxy function callProperty(name:*, ... rest) : *
      {
         var result:* = undefined;
         var nameAsString:String = null;
         var functionToCall:Function = null;
         nameAsString = String(name);
         try
         {
            functionToCall = this.doLookup(nameAsString);
            if(functionToCall != null)
            {
               result = functionToCall.apply(null,rest);
            }
            else
            {
               this.throwNonFunctionException(this.getFullyQualifiedName(nameAsString));
            }
         }
         catch(err:*)
         {
            throwNonFunctionException(getFullyQualifiedName(nameAsString));
         }
      }
      
      final override flash_proxy function nextNameIndex(index:int) : int
      {
         return 0;
      }
      
      private native function throwNonFunctionException(param1:String) : void;
   }
}

