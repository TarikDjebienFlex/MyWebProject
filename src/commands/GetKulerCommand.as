package commands
{
	import messages.GetKulerMessage;
	
	import models.DataModel;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.utils.ObjectUtil;
	
	import spark.primitives.Ellipse;

	public class GetKulerCommand
	{
		
		public const API_KEY:String = "282FED4BA884649B9ED06AFE5DB3BA2B";
		
		[Inject(id="service")]
		public var service:HTTPService;
		
		[Inject(id="model")]
		public var model:DataModel;
		
		public function GetKulerCommand()
		{
			trace("Constructor GetKulerCommand");
		}
		
		[Init]
		public function init():void
		{
			this.service.showBusyCursor = true;
			this.service.resultFormat = "xml";
		}
		
		[CommandResult(type="messages.GetKulerMessage", order="1")]
		public function handlerResult(event:ResultEvent):void
		{
			var data:XML = new XML(event.result);
			trace(data.toXMLString());
			var kulerNS:Namespace = data.namespace( "kuler" );
			var pattern:XMLList = data..kulerNS::swatchHexColor;
			var color:uint;
			
			for each (var swatch:XML in pattern){
				color = uint( "0x" + swatch.valueOf() );
				model.colors.push(color);
			}
			
		}
		
		[CommandError(type="messages.GetKulerMessage")]
		public function handlerFault(event:FaultEvent):void
		{
			trace(ObjectUtil.toString(event.fault));
		}
		
		[Command]
		public function onGetKulerMessageHandler(message:GetKulerMessage):AsyncToken
		{
			trace("onGetKulerMessageHandler : "+ message.terms);
			this.service.url = "http://kuler.adobe.com/kuler/API/rss/search.cfm?searchQuery="+message.terms;
			this.service.url += "&key="+API_KEY;
			this.service.url += "&itemsPerPage=3";
			
			return this.service.send();
		}
			
	}
}