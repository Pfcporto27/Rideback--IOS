# RideBack • Versión iOS (SwiftUI)

Esta carpeta contiene el código fuente nativo completo de **RideBack** para **iOS (iPhone)** desarrollado en **Swift** y **SwiftUI**.

---

## 📁 Archivos del Proyecto:

1. **`RideBackApp.swift`**: Punto de entrada principal de la aplicación (`@main`).
2. **`ContentView.swift`**: Interfaz de usuario completa en SwiftUI con diseño Glassmorphism, degradados oscuros, tarjetas traslúcidas, tipografía elegante y botones con sombras 3D y alineación perfecta de iconos y textos.
3. **`FallDetectorManager.swift`**: Controlador con `CoreMotion` (`CMMotionManager`) para monitoreo de caídas mediante acelerómetro, ráfagas de linterna (`AVCaptureDevice`) y alertas hápticas y sonoras (`AudioToolbox`).
4. **`RecoveryStorage.swift`**: Gestión de persistencia de datos con `UserDefaults` y cifrado SHA-256 / PBKDF2 mediante `CryptoKit`.
5. **`QRCodeGenerator.swift`**: Generador nativo de códigos QR usando filtros de `CoreImage`.

---

## 🛠️ Cómo abrir y compilar en Xcode (Mac):

1. Abre **Xcode** en tu ordenador Mac.
2. Selecciona **File > New > Project...** y elige la plantilla **App** de **iOS**.
3. Nombra el proyecto como `RideBack` y asegúrate de seleccionar **Language: Swift** e **Interface: SwiftUI**.
4. Copia los archivos `.swift` de esta carpeta a tu proyecto de Xcode.
5. Selecciona tu iPhone o un simulador e inicia la compilación presionando `Cmd + R`.

---

## ☁️ Compilación en la Nube desde Windows (Sin Mac Físico):

Si estás trabajando desde **Windows**, puedes compilar esta carpeta enviando el código a un servicio de CI/CD gratuito en la nube:
- **Codemagic**: Conecta tu repositorio y selecciona la plantilla *iOS App*.
- **Bitrise**: Automatiza la creación del paquete `.ipa`.
- **GitHub Actions**: Utiliza un runner `macos-latest` para ejecutar `xcodebuild`.
