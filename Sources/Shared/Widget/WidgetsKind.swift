import Foundation

public enum WidgetsKind: String, CaseIterable {
    case assist = "WidgetAssist"
    case actions = "WidgetActions"
    case openPage = "WidgetOpenPage"
    case gauge = "WidgetGauge"
    case details = "WidgetDetails"
    case scripts = "WidgetScripts"
    case controlScript
    case controlScene
    case controlAssist
    case controlOpenPage
    case controlLight
}
