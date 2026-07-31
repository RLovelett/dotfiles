import QtQuick
import Quickshell.Bluetooth
import Quickshell.Networking

QtObject {
  required property NetworkInfo networkInfo

  readonly property var connectedDevice: Networking.devices.values.find(device => device.connected) || null
  readonly property var connectedNetwork: {
    if (connectedDevice === null || connectedDevice.type !== DeviceType.Wifi)
      return null
    return connectedDevice.networks.values.find(network => network.connected) || null
  }
  readonly property bool networkIsWifi: connectedDevice !== null && connectedDevice.type === DeviceType.Wifi
  readonly property bool networkIsWired: connectedDevice !== null && connectedDevice.type === DeviceType.Wired
  readonly property bool networkAvailable: connectedDevice !== null
  readonly property string networkName: networkIsWifi && connectedNetwork !== null
    ? connectedNetwork.name
    : networkIsWired ? "Ethernet" : "Offline"
  readonly property string networkAddress: networkAvailable ? networkInfo.address : "No address"
  readonly property real wifiStrength: connectedNetwork !== null ? connectedNetwork.signalStrength : 0
  readonly property int bluetoothCount: Bluetooth.devices.values.filter(device => device.connected).length
  readonly property bool bluetoothEnabled: Bluetooth.defaultAdapter !== null && Bluetooth.defaultAdapter.enabled
}
