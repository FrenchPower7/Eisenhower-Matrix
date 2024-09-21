# Charger l'assembly Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Créer la fenêtre principale
$form = New-Object System.Windows.Forms.Form
$form.Text = "Matrice d'Eisenhower"
$form.Size = New-Object System.Drawing.Size(500, 500)

# Définir la taille des quadrants
$width = 240
$height = 200

# Le style de police
$font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)

# Initialiser une structure de données vide pour stocker les tâches
$tasks = @{
    "UrgentImportant"      = @()
    "NonUrgentImportant"   = @()
    "UrgentNonImportant"   = @()
    "NonUrgentNonImportant"= @()
}

# Lire le fichier texte et remplir la structure de données
$filePath = "C:\Users\Ethan B\OneDrive - Reseau-GES\Bureau\Matrice\taches.txt"
if (Test-Path $filePath) {
    Get-Content $filePath | ForEach-Object {
        $parts = $_ -split ":", 2
        if ($parts.Length -eq 2) {
            $quadrant = $parts[0]
            $task = $parts[1]
            if ($tasks.ContainsKey($quadrant)) {
                $tasks[$quadrant] += $task
            }
        } else {
            Write-Host "Ligne invalide : $_"
        }
    }
} else {
    Write-Host "Le fichier spécifié n'existe pas."
}

# Fonction pour créer un quadrant avec ses tâches
function Create-QuadrantPanel {
    param (
        [string]$title,
        [array]$taskList,
        [System.Drawing.Point]$location
    )

    $panel = New-Object System.Windows.Forms.Panel
    $panel.BorderStyle = 'FixedSingle'
    $panel.Size = New-Object System.Drawing.Size($width, $height)
    $panel.Location = $location

    $labelTitle = New-Object System.Windows.Forms.Label
    $labelTitle.Text = $title
    $labelTitle.Font = $font
    $labelTitle.AutoSize = $true
    $labelTitle.Location = New-Object System.Drawing.Point(10, 10)
    $panel.Controls.Add($labelTitle)

    # Afficher les tâches dans le quadrant
    $yPosition = 40
    foreach ($task in $taskList) {
        $labelTask = New-Object System.Windows.Forms.Label
        $labelTask.Text = "- $task"
        $labelTask.AutoSize = $true
        $labelTask.Location = New-Object System.Drawing.Point(10, $yPosition)
        $panel.Controls.Add($labelTask)
        $yPosition += 20
    }

    return $panel
}

# Créer les quadrants avec les tâches
$panel1 = Create-QuadrantPanel "Urgent et Important" $tasks["UrgentImportant"] (New-Object System.Drawing.Point(10, 10))
$panel2 = Create-QuadrantPanel "Non Urgent mais Important" $tasks["NonUrgentImportant"] (New-Object System.Drawing.Point(260, 10))
$panel3 = Create-QuadrantPanel "Urgent mais Non Important" $tasks["UrgentNonImportant"] (New-Object System.Drawing.Point(10, 220))
$panel4 = Create-QuadrantPanel "Non Urgent et Non Important" $tasks["NonUrgentNonImportant"] (New-Object System.Drawing.Point(260, 220))

# Ajouter les panneaux à la fenêtre
$form.Controls.Add($panel1)
$form.Controls.Add($panel2)
$form.Controls.Add($panel3)
$form.Controls.Add($panel4)

# Afficher la fenêtre
$form.ShowDialog()
