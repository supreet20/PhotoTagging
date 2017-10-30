import UIKit
import Speech
import AVFoundation

class TagsColorsTableViewController: UITableViewController {

  // MARK: - Properties
  var data: [TagsColorTableData] = []

	var flag = 1
	
	func say() {
		flag = 0
		var text = "This image contains"
		for i in 0 ... 9 {
			if i<data.count {
				let d =  data[i].label
				print(d)
				text += (" " + d)
			}
		}
		let speechUtterance = AVSpeechUtterance(string: text)
		speechUtterance.volume = 1.0
		speechUtterance.rate = 0.5
		let speechSynthesizer = AVSpeechSynthesizer()
		
		speechSynthesizer.speak(speechUtterance)
	}
}

// MARK: - UITableViewDataSource
extension TagsColorsTableViewController {

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if data.count != 0  && flag == 1{
			say()
		}
    return data.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellData = data[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "TagOrColorCell", for: indexPath)
    cell.textLabel?.text = cellData.label
    return cell
  }
}

// MARK: - UITableViewDelegate
extension TagsColorsTableViewController {

  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let cellData = data[indexPath.row]

    guard let color = cellData.color else {
      cell.textLabel?.textColor = .black
      cell.backgroundColor = .white
      return
    }

    var red = CGFloat(0.0), green = CGFloat(0.0), blue = CGFloat(0.0), alpha = CGFloat(0.0)
    color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    let threshold = CGFloat(105)
    let bgDelta = ((red * 0.299) + (green * 0.587) + (blue * 0.114));

    let textColor: UIColor = (255 - bgDelta < threshold) ? .black : .white;
    cell.textLabel?.textColor = textColor
    cell.backgroundColor = color
  }
}
