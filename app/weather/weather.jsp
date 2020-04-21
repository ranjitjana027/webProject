
		<script type="text/javascript">


			function showPosition(position) {
					lat= position.coords.latitude ;
					lon= position.coords.longitude;
					weatherUpdate(lat,lon);
				}
			navigator.geolocation.getCurrentPosition(showPosition);
			function weatherUpdate(lat,lon){
				var request=new XMLHttpRequest();
				request.open("GET", location.protocol+"//"+location.host+"/farmer/app/weather/weatherJSON.jsp?lat="+lat+"&lon="+lon+"&appid=bbd7cea7000ec20b5d560c73b59adcc4&units=metric");
				request.onload=()=>{
					data=JSON.parse(request.responseText);
					city=data["name"];
					desc=data["weather"][0]["description"];
					temp=Number(data["main"]["temp"]).toFixed(1);
					feels_like=Number(data["main"]["feels_like"]).toFixed(1);
					humidity=(data["main"]["humidity"]);
					temp_min=Number(data["main"]["temp_min"]).toFixed(1);
					temp_max = Number(data["main"]["temp_max"]).toFixed(1);
					sunrise=new Date(Number(data["sys"]["sunrise"]) * 1000).toLocaleTimeString();
					sunset= new Date(Number(data["sys"]["sunset"]) * 1000).toLocaleTimeString();



					document.querySelector('#weather-details').innerHTML="<li>City: "
					+city+"</li><li>Weather: "
					+desc +"</li><li>Temperature: "
					+temp+" &deg;c</li><li>Feels like: "
					+feels_like+" &deg;c</li><li>Humidity: "
					+humidity+"&#37;</li>"/*"<li>Minimum Temperature: "
					+ temp_min+" &deg;c</li><li>Maximum Temperatur: "
					+temp_max+" &deg;c</li>*/+ "<li>Sunrise: "
					+sunrise+"</li><li>Sunset: "
					+sunset+"</li>";

				}
				request.send();
			}
		</script>
		<div style="height: 100%; background-image: url('/farmer/assets/img/images.png'); background-size: contain; background-size: cover;">
			<ul id="weather-details" style="padding: 10px; margin: 0; color: navy ; ">

			</ul>
		</div>