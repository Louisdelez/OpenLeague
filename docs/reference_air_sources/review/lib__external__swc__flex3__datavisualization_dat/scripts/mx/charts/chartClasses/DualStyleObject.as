package mx.charts.chartClasses
{
   import mx.core.IFlexDisplayObject;
   import mx.core.UIComponent;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.IStyleClient;
   import mx.styles.StyleManager;
   import mx.styles.StyleProtoChain;
   
   public class DualStyleObject extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _internalStyleName:Object;
      
      public function DualStyleObject()
      {
         super();
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function initProtoChain() : void
      {
         var classSelector:CSSStyleDeclaration = null;
         var internalClassSelector:CSSStyleDeclaration = null;
         var inheritChain:Object = null;
         var typeSelector:CSSStyleDeclaration = null;
         if(Boolean(styleName))
         {
            if(styleName is CSSStyleDeclaration)
            {
               classSelector = CSSStyleDeclaration(styleName);
            }
            else
            {
               if(styleName is IFlexDisplayObject)
               {
                  StyleProtoChain.initProtoChainForUIComponentStyleName(this);
                  return;
               }
               if(styleName is String)
               {
                  classSelector = StyleManager.getStyleDeclaration("." + styleName);
               }
            }
         }
         if(Boolean(internalStyleName))
         {
            if(internalStyleName is CSSStyleDeclaration)
            {
               internalClassSelector = CSSStyleDeclaration(internalStyleName);
            }
            else
            {
               if(internalStyleName is IFlexDisplayObject)
               {
                  StyleProtoChain.initProtoChainForUIComponentStyleName(this);
                  return;
               }
               if(internalStyleName is String)
               {
                  internalClassSelector = StyleManager.getStyleDeclaration("." + internalStyleName);
               }
            }
         }
         var nonInheritChain:Object = StyleManager.stylesRoot;
         if(Boolean(nonInheritChain.effects))
         {
            registerEffects(nonInheritChain.effects);
         }
         var p:IStyleClient = parent as IStyleClient;
         if(Boolean(p))
         {
            inheritChain = p.inheritingStyles;
            if(inheritChain == UIComponent.STYLE_UNINITIALIZED)
            {
               inheritChain = nonInheritChain;
            }
         }
         else
         {
            inheritChain = StyleManager.stylesRoot;
         }
         var typeSelectors:Array = getClassStyleDeclarations();
         var n:int = int(typeSelectors.length);
         for(var i:int = 0; i < n; i++)
         {
            typeSelector = typeSelectors[i];
            inheritChain = typeSelector.addStyleToProtoChain(inheritChain,this);
            nonInheritChain = typeSelector.addStyleToProtoChain(nonInheritChain,this);
            if(Boolean(typeSelector.effects))
            {
               registerEffects(typeSelector.effects);
            }
         }
         if(Boolean(internalClassSelector))
         {
            inheritChain = internalClassSelector.addStyleToProtoChain(inheritChain,this);
            nonInheritChain = internalClassSelector.addStyleToProtoChain(nonInheritChain,this);
            if(Boolean(internalClassSelector.effects))
            {
               registerEffects(internalClassSelector.effects);
            }
         }
         if(Boolean(classSelector))
         {
            inheritChain = classSelector.addStyleToProtoChain(inheritChain,this);
            nonInheritChain = classSelector.addStyleToProtoChain(nonInheritChain,this);
            if(Boolean(classSelector.effects))
            {
               registerEffects(classSelector.effects);
            }
         }
         inheritingStyles = Boolean(styleDeclaration) ? styleDeclaration.addStyleToProtoChain(inheritChain,this) : inheritChain;
         nonInheritingStyles = Boolean(styleDeclaration) ? styleDeclaration.addStyleToProtoChain(nonInheritChain,this) : nonInheritChain;
      }
      
      public function set internalStyleName(v:Object) : void
      {
         if(_internalStyleName == v)
         {
            return;
         }
         _internalStyleName = v;
         if(inheritingStyles != UIComponent.STYLE_UNINITIALIZED)
         {
            regenerateStyleCache(true);
            initThemeColor();
            styleChanged("internalStyleName");
            styleChanged("styleName");
            notifyStyleChangeInChildren("styleName",true);
         }
      }
      
      [Inspectable(environment="none")]
      public function get internalStyleName() : Object
      {
         return _internalStyleName;
      }
   }
}

