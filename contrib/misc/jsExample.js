function start(svgObject){
	console.log("ok")
	const texts = svgObject.getElementsByTagName('text')
	    for (let text of texts) {
	    	text.setAttribute("style", text.getAttribute("style") + ";pointer-events:none;")
	    }

	const elements = svgObject.getElementsByTagName('rect')

	    for (let element of elements) {
	    	if(!element.id.includes("Bridge")){
	    		element.addEventListener('mouseup', function(e) {

				    target = e.target
				    oldColor = target.getAttribute("saveColor")

				    if(!oldColor){
				    	target.setAttribute("saveColor", target.getAttribute("fill"))
						target.setAttribute("fill", "red")
				    }else{
				    	target.setAttribute("fill", oldColor)
				    	target.removeAttribute("saveColor")
				    }
				    changeText(target, svgObject)
    			})
	    	}	    	
		}
}

function changeText(element, svgObject){
	const text = getText(element.id, svgObject)

	let textContent = element.getAttribute("saveText")

	if(!textContent){
		element.setAttribute("saveText", text.innerHTML)
		textContent = element.getAttribute("width") > 90 ? "id : " + text.id : text.id.slice(-0,-5) + ".."
	}else{
		element.removeAttribute("saveText")
	}

	let svg   = svgObject.documentElement;
	let svgNS = svg.namespaceURI;
	let newText = document.createElementNS(svgNS, "text");
	newText.setAttributeNS(null,"x", text.getAttribute("x"));
	newText.setAttributeNS(null,"y", text.getAttribute("y"));
	newText.setAttributeNS(null,"width", text.getAttribute("width"));
	newText.setAttributeNS(null,"height", text.getAttribute("height"));
	newText.setAttributeNS(null,"font-size",text.getAttribute("font-size"));
	newText.setAttributeNS(null,"font-family",text.getAttribute("font-family"));
	newText.setAttributeNS(null,"class",text.getAttribute("class"));
	newText.setAttributeNS(null,"fill",text.getAttribute("fill"));
	newText.setAttributeNS(null,"style",text.getAttribute("style"));
	newText.setAttributeNS(null,"id",text.getAttribute("id"));

	newText.appendChild(svgObject.createTextNode(textContent));
	svg.removeChild(text)
	svg.appendChild(newText)
}

function getText(id, svgObject){
	let textId = id.replace('rect', 'text')
	const text = svgObject.getElementById(textId)

	return text
}