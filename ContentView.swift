import SwiftUI

struct ContentView: View {
    @EnvironmentObject var motionManager: FallDetectorManager

    @State private var ownerInput: String = RecoveryStorage.owner
    @State private var contactInput: String = RecoveryStorage.contact
    @State private var pinInput: String = ""

    @State private var qrImage: UIImage? = nil
    @State private var showQrSheet: Bool = false
    @State private var alertMessage: String? = nil
    @State private var showAlert: Bool = false

    var body: some View {
        ZStack {
            // Fondo oscuro con degradado
            Color(hex: "#0A0A12")
                .ignoresSafeArea()

            // Orbes brillantes de fondo
            GeometryReader { geometry in
                Circle()
                    .fill(RadialGradient(colors: [Color(hex: "#2A1F6B").opacity(0.7), Color.clear], center: .center, startRadius: 0, endRadius: 250))
                    .frame(width: 450, height: 450)
                    .offset(x: -100, y: -120)
                    .blur(radius: 30)

                Circle()
                    .fill(RadialGradient(colors: [Color(hex: "#00E5FF").opacity(0.12), Color.clear], center: .center, startRadius: 0, endRadius: 200))
                    .frame(width: 400, height: 400)
                    .offset(x: geometry.size.width - 200, y: geometry.size.height - 250)
                    .blur(radius: 40)
            }

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    Spacer().frame(height: 10)

                    // CARD 1: ESTADO Y CONTROL DE PROTECCIÓN
                    EleganteGlassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                HStack(spacing: 12) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(hex: motionManager.statusColorHex).opacity(0.15))
                                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: motionManager.statusColorHex).opacity(0.25), lineWidth: 1))
                                            .frame(width: 42, height: 42)
                                        Image(systemName: "checkmark.shield.fill")
                                            .foregroundColor(Color(hex: motionManager.statusColorHex))
                                            .font(.system(size: 20, weight: .semibold))
                                    }

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("RideBack")
                                            .font(.system(size: 17, weight: .bold, design: .default))
                                            .foregroundColor(.white)
                                        Text("Protección total de Teléfonos")
                                            .font(.system(size: 10.5, weight: .medium, design: .default))
                                            .foregroundColor(.white.opacity(0.5))
                                            .lineLimit(1)
                                    }
                                }

                                Spacer()

                                Toggle("", isOn: Binding(
                                    get: { motionManager.isProtectionActive },
                                    set: { _ in motionManager.toggleProtection() }
                                ))
                                .labelsHidden()
                                .tint(Color(hex: "#10B981"))
                            }

                            Text("Sistema inteligente contra caídas y olvidos en vehículos.")
                                .font(.system(size: 13, weight: .regular))
                                .foregroundColor(.white.opacity(0.55))

                            // Badge de estado
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(Color(hex: motionManager.statusColorHex))
                                    .frame(width: 7, height: 7)
                                Text(motionManager.statusMessage)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(Color(hex: motionManager.statusColorHex))
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color(hex: motionManager.statusColorHex).opacity(0.12))
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color(hex: motionManager.statusColorHex).opacity(0.25), lineWidth: 1))

                            // Botón 3D de Protección
                            Button(action: {
                                motionManager.toggleProtection()
                            }) {
                                HStack {
                                    HStack(spacing: 12) {
                                        ZStack {
                                            Circle()
                                                .fill(motionManager.isProtectionActive ? Color(hex: "#E05252").opacity(0.18) : Color(hex: "#3B82F6").opacity(0.18))
                                                .frame(width: 38, height: 38)
                                            Image(systemName: "shield.fill")
                                                .foregroundColor(motionManager.isProtectionActive ? Color(hex: "#EF4444") : Color(hex: "#3B82F6"))
                                                .font(.system(size: 18))
                                        }

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(motionManager.isProtectionActive ? "Protección Activa" : "Activar Protección RideBack")
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(.white)
                                            Text(motionManager.isProtectionActive ? "Toca para desactivar" : "Toca para iniciar guardia")
                                                .font(.system(size: 11, weight: .medium))
                                                .foregroundColor(motionManager.isProtectionActive ? Color(hex: "#EF4444").opacity(0.8) : Color(hex: "#3B82F6").opacity(0.8))
                                        }
                                    }

                                    Spacer()

                                    ZStack {
                                        Circle()
                                            .fill(Color.white.opacity(0.05))
                                            .frame(width: 28, height: 28)
                                            .overlay(Circle().stroke(Color.white.opacity(0.08), lineWidth: 1))
                                        Image(systemName: "arrow.up.right")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(.white.opacity(0.6))
                                    }
                                }
                                .padding(16)
                                .background(
                                    motionManager.isProtectionActive ?
                                    LinearGradient(colors: [Color(hex: "#2A1A1E"), Color(hex: "#1F1518")], startPoint: .topLeading, endPoint: .bottomTrailing) :
                                    LinearGradient(colors: [Color(hex: "#1E295E"), Color(hex: "#131B3D")], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                                .overlay(RoundedRectangle(cornerRadius: 18).stroke(motionManager.isProtectionActive ? Color(hex: "#E05252").opacity(0.3) : Color(hex: "#3B82F6").opacity(0.3), lineWidth: 1))
                                .shadow(color: motionManager.isProtectionActive ? Color(hex: "#E05252").opacity(0.2) : Color(hex: "#2563EB").opacity(0.2), radius: 8, x: 0, y: 4)
                            }
                        }
                        .padding(20)
                    }

                    // CARD 2: RECUPERACIÓN Y PIN
                    EleganteGlassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                HStack(spacing: 10) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.white.opacity(0.06))
                                            .frame(width: 32, height: 32)
                                        Image(systemName: "person.fill")
                                            .foregroundColor(.white.opacity(0.7))
                                            .font(.system(size: 15))
                                    }
                                    Text("Recuperación y PIN")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                Spacer()
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                LabelElegante("PROPIETARIO / ETIQUETA")
                                ElegantInputField(iconName: "person", placeholder: "Nombre o etiqueta del propietario", text: $ownerInput)
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                LabelElegante("TELÉFONO DE CONTACTO DE EMERGENCIA")
                                ElegantInputField(iconName: "phone", placeholder: "Teléfono de emergencia (+34...)", text: $contactInput, keyboardType: .phonePad)
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    LabelElegante("PIN DE RECUPERACIÓN")
                                    Spacer()
                                    Text("6 dígitos")
                                        .font(.system(size: 10.5))
                                        .foregroundColor(.white.opacity(0.3))
                                }
                                ElegantInputField(iconName: "key", placeholder: "Crear PIN de 6 dígitos", text: $pinInput, isSecure: true, keyboardType: .numberPad)
                            }

                            Text("Este PIN aparecerá en tu pantalla de recuperación para verificar devolución.")
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.35))

                            // Botón Guardar con Relieve 3D
                            Button(action: {
                                saveSettings()
                            }) {
                                ZStack {
                                    LinearGradient(colors: [Color(hex: "#6D6CFF"), Color(hex: "#5A59E0")], startPoint: .top, endPoint: .bottom)

                                    VStack {
                                        Color.white.opacity(0.3).frame(height: 1)
                                        Spacer()
                                    }

                                    HStack(spacing: 8) {
                                        Image(systemName: "square.and.arrow.down.fill")
                                            .font(.system(size: 16, weight: .bold))
                                        Text("Guardar Datos y PIN")
                                            .font(.system(size: 14, weight: .bold))
                                    }
                                    .foregroundColor(.white)
                                }
                                .frame(height: 52)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(LinearGradient(colors: [.white.opacity(0.3), .white.opacity(0.05)], startPoint: .top, endPoint: .bottom), lineWidth: 1))
                                .shadow(color: Color(hex: "#6366F1").opacity(0.4), radius: 10, x: 0, y: 5)
                            }
                        }
                        .padding(20)
                    }

                    // CARD 3: PANEL DE PRUEBAS Y FUNCIONES
                    EleganteGlassCard {
                        VStack(alignment: .leading, spacing: 14) {
                            HStack(spacing: 10) {
                                ZStack {
                                    Circle()
                                        .fill(Color(hex: "#6366F1").opacity(0.15))
                                        .frame(width: 32, height: 32)
                                    Image(systemName: "bolt.fill")
                                        .foregroundColor(Color(hex: "#6366F1"))
                                        .font(.system(size: 15))
                                }
                                Text("Panel de Pruebas y Funciones")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.white)
                            }

                            Spacer().frame(height: 4)

                            EleganteActionButtonWithIcon(iconName: "qrcode", text: "Ver Código QR de Recuperación") {
                                generateAndShowQr()
                            }

                            EleganteActionButtonWithIcon(iconName: "flashlight.on.fill", text: "Probar 3 Destellos de Linterna + Sonido") {
                                motionManager.triggerThreePulseAlert()
                                triggerToast("Prueba de 3 destellos + alarma")
                            }

                            EleganteActionButtonWithIcon(iconName: "car.fill", text: "Probar Alerta de Chofer\n(Voz + QR + Pantalla)") {
                                triggerToast("Abriendo alerta de chofer...")
                            }

                            EleganteActionButtonWithIcon(iconName: "bell.fill", text: "Aviso 5 min. Durante Viaje") {
                                motionManager.triggerSoftBeep()
                                triggerToast("¡¡MANTÉN EL MÓVIL A SALVO, ESTOY CONTIGO!!")
                            }

                            EleganteActionButtonWithIcon(iconName: "lock.fill", text: "Probar Pantalla QR\nsobre Bloqueo") {
                                triggerToast("Probrando pantalla sobre bloqueo")
                            }

                            EleganteActionButtonWithIcon(iconName: "gearshape.fill", text: "Abrir Ajustes") {
                                triggerToast("Abriendo ajustes...")
                            }
                        }
                        .padding(20)
                    }

                    // OVERLAY TARJETA QR GENERADA
                    if let image = qrImage, showQrSheet {
                        EleganteGlassCard {
                            VStack(spacing: 16) {
                                HStack(spacing: 8) {
                                    Image(systemName: "qrcode")
                                        .foregroundColor(Color(hex: "#6366F1"))
                                        .font(.system(size: 18, weight: .bold))
                                    Text("Código QR de Recuperación")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(.white)
                                }

                                VStack(spacing: 4) {
                                    Text("PROPIETARIO: \(RecoveryStorage.owner.uppercased())")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)

                                    Text("TELÉFONO: \(RecoveryStorage.contact)")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.8))
                                        .multilineTextAlignment(.center)
                                }

                                Image(uiImage: image)
                                    .resizable()
                                    .interpolation(.none)
                                    .scaledToFit()
                                    .frame(width: 200, height: 200)
                                    .padding(12)
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))

                                Button(action: { showQrSheet = false }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "xmark")
                                        Text("Cerrar QR")
                                    }
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color.white.opacity(0.1))
                                    .clipShape(Capsule())
                                }
                            }
                            .padding(20)
                        }
                    }

                    // STATS FOOTER
                    HStack(spacing: 10) {
                        EleganteStatCard(iconName: "shield.fill", title: "Protección", value: motionManager.isProtectionActive ? "Activa" else "Inactiva")
                        EleganteStatCard(iconName: "sensor.fill", title: "Sensor", value: "Caídas")
                        EleganteStatCard(iconName: "checkmark.seal.fill", title: "Versión", value: "5.0 PRO")
                    }

                    Text("RideBack • Protección Inteligente en Vehículos")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.3))
                        .padding(.top, 10)

                    Spacer().frame(height: 20)
                }
                .padding(.horizontal, 20)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("RideBack"), message: Text(alertMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }

    private func saveSettings() {
        if RecoveryStorage.saveSettings(owner: ownerInput, contact: contactInput, pin: pinInput) {
            pinInput = ""
            motionManager.startProtection()
            triggerToast("Datos guardados y protección activada.")
        } else {
            triggerToast("Revisa los datos: etiqueta válida, teléfono de 7+ dígitos y PIN de 6 dígitos.")
        }
    }

    private func generateAndShowQr() {
        let owner = RecoveryStorage.owner
        let contact = RecoveryStorage.contact
        guard !owner.isEmpty, !contact.isEmpty else {
            triggerToast("Primero guarda el propietario y el contacto.")
            return
        }
        let qrString = "RideBack recovery\nOwner: \(owner)\nContact: \(contact)\nCall: tel:\(contact)"
        if let generated = QRCodeGenerator.generateQRCode(from: qrString) {
            self.qrImage = generated
            self.showQrSheet = true
        } else {
            triggerToast("No se pudo generar el código QR.")
        }
    }

    private func triggerToast(_ text: String) {
        self.alertMessage = text
        self.showAlert = true
    }
}

// MARK: - COMPONENTES REUTILIZABLES DE DISEÑO

struct EleganteGlassCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28)
                .fill(LinearGradient(colors: [Color(hex: "#1C1C28"), Color(hex: "#16161F")], startPoint: .topLeading, endPoint: .bottomTrailing))
                .overlay(RoundedRectangle(cornerRadius: 28).stroke(Color.white.opacity(0.08), lineWidth: 1))
            content
        }
    }
}

struct LabelElegante: View {
    let text: String
    init(_ text: String) { self.text = text }

    var body: some View {
        Text(text)
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(.white.opacity(0.4))
            .tracking(0.8)
    }
}

struct ElegantInputField: View {
    let iconName: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .foregroundColor(.white.opacity(0.35))
                .font(.system(size: 16))
                .frame(width: 20)

            if isSecure {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .keyboardType(keyboardType)
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .keyboardType(keyboardType)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(Color(hex: "#12121A"))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.12), lineWidth: 1))
    }
}

struct EleganteActionButtonWithIcon: View {
    let iconName: String
    let text: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white.opacity(0.06))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.08), lineWidth: 1))

                HStack {
                    Image(systemName: iconName)
                        .foregroundColor(Color(hex: "#818CF8"))
                        .font(.system(size: 17, weight: .semibold))
                        .padding(.leading, 16)

                    Spacer()
                }

                Text(text)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 40)
            }
            .frame(minHeight: 52)
        }
    }
}

struct EleganteStatCard: View {
    let iconName: String
    let title: String
    let value: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.04))

            VStack(spacing: 4) {
                Image(systemName: iconName)
                    .foregroundColor(Color(hex: "#6366F1").opacity(0.8))
                    .font(.system(size: 16))

                Text(value)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Text(title)
                    .font(.system(size: 10, weight: .regular))
                    .foregroundColor(.white.opacity(0.45))
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 4)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - EXTENSIÓN PARA COLOR HEX EN SWIFTUI
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 1)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
