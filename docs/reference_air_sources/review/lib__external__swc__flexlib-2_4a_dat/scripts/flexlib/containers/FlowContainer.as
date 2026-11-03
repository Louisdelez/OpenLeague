package flexlib.containers
{
   import flexlib.containers.utilityClasses.AdobeFlowLayout;
   import mx.core.Container;
   
   [Exclude(name="focusOutEffect",kind="effect")]
   [Exclude(name="focusInEffect",kind="effect")]
   [Exclude(name="focusThickness",kind="style")]
   [Exclude(name="focusSkin",kind="style")]
   [Exclude(name="focusBlendMode",kind="style")]
   [Exclude(name="focusOut",kind="event")]
   [Exclude(name="focusIn",kind="event")]
   [Style(name="verticalGap",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   public class FlowContainer extends Container
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var layoutObject:AdobeFlowLayout = new AdobeFlowLayout();
      
      public function FlowContainer()
      {
         super();
         horizontalScrollPolicy = "off";
         layoutObject.target = this;
      }
      
      override protected function measure() : void
      {
         super.measure();
         layoutObject.measure();
      }
      
      override public function set height(newHeight:Number) : void
      {
         layoutObject.explicitHeightSet = true;
         super.height = newHeight;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         layoutObject.updateDisplayList(unscaledWidth,unscaledHeight);
      }
   }
}

