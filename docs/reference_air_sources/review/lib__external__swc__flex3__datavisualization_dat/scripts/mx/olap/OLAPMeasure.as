package mx.olap
{
   import mx.olap.aggregators.AverageAggregator;
   import mx.olap.aggregators.CountAggregator;
   import mx.olap.aggregators.MaxAggregator;
   import mx.olap.aggregators.MinAggregator;
   import mx.olap.aggregators.SumAggregator;
   import mx.resources.ResourceManager;
   
   [ResourceBundle("olap")]
   public class OLAPMeasure extends OLAPMember
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _aggregator:Object = new SumAggregator();
      
      public function OLAPMeasure(name:String = null, displayName:String = null)
      {
         super(name,displayName);
      }
      
      public function set aggregator(value:Object) : void
      {
         var message:String = null;
         _aggregator = value;
         if(value is String)
         {
            switch(String(value).toLowerCase())
            {
               case "sum":
                  _aggregator = new SumAggregator();
                  break;
               case "count":
                  _aggregator = new CountAggregator();
                  break;
               case "avg":
                  _aggregator = new AverageAggregator();
                  break;
               case "max":
                  _aggregator = new MaxAggregator();
                  break;
               case "min":
                  _aggregator = new MinAggregator();
                  break;
               default:
                  _aggregator = null;
                  message = ResourceManager.getInstance().getString("olap","invalidAggregator",[value]);
                  throw Error(message);
            }
         }
      }
      
      override public function get isMeasure() : Boolean
      {
         return true;
      }
      
      public function get aggregator() : Object
      {
         return _aggregator;
      }
   }
}

