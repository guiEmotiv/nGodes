VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CTemptativeIterationPlansSet"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private m_GuardTemptativePlans() As Collection
Private m_GuardTemptativePlan As CGuardTemptativePlan
Private m_TOPScore As Single
Public StopIteration As Boolean
Public m_CoverageScore As Single
Private m_CoverageforSite() As Single
Private m_SiteCovered() As Single
Private m_CoverageforTimeStep() As Single
Private m_CoverageforTimeStepRaw() As Single
Private m_SurvivalforTimeStep() As Single



Private m_ActualPositionX() As Single
Private m_ActualPositionY() As Single
Private m_ActualGuardStatus() As String
Private m_CollectedTopScore As Single
Private m_LastTaskCounterL0() As Integer
Private m_IterationAccomplishedTasks() As Integer

Private m_CollectedTopScoreNormal As Single
Private m_CollectedAlarmScore As Single

Private CummulativeCoverers As Single


Private m_OriginXPositionNextL1() As Single
Private m_OriginYPositionNextL1() As Single
Private m_EmergencyVerifierNextL1() As Boolean
Private m_StartingTaskNextL1() As Single
Private m_SimulationXPositionNextL1() As Single
Private m_SimulationYPositionNextL1() As Single
Private m_LiberationTimeNextL1() As Single

Property Get SurvivalforTimeStep(var_step_counter As Integer) As Single
SurvivalforTimeStep = m_SurvivalforTimeStep(var_step_counter)
End Property



Property Get GuardTemptativePlans() As Collection
GuardTemptativePlans(temptative_iteration_counter) = m_GuardTemptativePlans(temptative_iteration_counter)
End Property
Property Get TOPScore() As Single
TOPScore = m_TOPScore
End Property
Property Get CoverageScore() As Single
CoverageScore = m_CoverageScore
End Property
Property Get CoverageforSite(var_step_counter As Integer, var_site_counter As Integer) As Variant
CoverageforSite(var_step_counter, var_site_counter) = m_CoverageforSite(var_step_counter, var_site_counter)
End Property

Property Get SiteCovered(var_step_counter As Integer, var_site_counter As Integer) As Single
SiteCovered(var_step_counter, var_site_counter) = m_SiteCovered(var_step_counter, var_site_counter)
End Property

Public Function SiteCoveredf(var_step_counter As Integer, var_site_counter As Integer) As Single
SiteCoveredf = m_SiteCovered(var_step_counter, var_site_counter)
End Function




Property Get CoverageforTimeStep(var_step_counter As Integer) As Single
CoverageforTimeStep = m_CoverageforTimeStep(var_step_counter)
End Property

Property Get CoverageforTimeStepRaw(var_step_counter As Integer) As Single
CoverageforTimeStepRaw = m_CoverageforTimeStepRaw(var_step_counter)
End Property


Property Get ActualPositionX(var_step_counter As Integer, var_guard_counter As Integer) As Single
ActualPositionX = m_ActualPositionX(var_step_counter, var_guard_counter)
End Property
Property Get ActualPositionY(var_step_counter As Integer, var_guard_counter As Integer) As Single
ActualPositionY = m_ActualPositionY(var_step_counter, var_guard_counter)
End Property
Property Get ActualGuardStatus(var_step_counter As Integer, var_guard_counter As Integer) As String
ActualGuardStatus = m_ActualGuardStatus(var_step_counter, var_guard_counter)
End Property
Public Function ActualPositionfX(var_step_counter As Integer, var_guard_counter As Integer) As Single
ActualPositionfX = m_ActualPositionX(var_step_counter, var_guard_counter)
End Function
Public Function ActualPositionfY(var_step_counter As Integer, var_guard_counter As Integer) As Single
ActualPositionfY = m_ActualPositionY(var_step_counter, var_guard_counter)
End Function
Public Function ActualGuardStatusf(var_step_counter As Integer, var_guard_counter As Integer) As String
ActualGuardStatusf = m_ActualGuardStatus(var_step_counter, var_guard_counter)
End Function



Public Function CoverageforSitef(var_step_counter As Integer, var_site_counter As Integer) As Variant
CoverageforSitef = m_CoverageforSite(var_step_counter, var_site_counter)
End Function
Public Function CoverageforTimeStepf(var_step_counter As Integer) As Single
CoverageforTimeStepf = m_CoverageforTimeStep(var_step_counter)
End Function
Property Get LastTaskCounterL0(var_guardcounter2 As Integer) As Integer
LastTaskCounterL0 = m_LastTaskCounterL0(var_guardcounter2)
End Property
Property Get LastTaskCounterfL0(var_guardcounter2 As Integer) As Integer
LastTaskCounterfL0 = m_LastTaskCounterL0(var_guardcounter2)
End Property
Property Get IterationAccomplishedTasks(var_guardcounter As Integer, var_taskguardcounter As Integer) As Integer
IterationAccomplishedTasks = m_IterationAccomplishedTasks(var_guardcounter, var_taskguardcounter)
End Property
Public Function IterationAccomplishedTasksf(var_guardcounter As Integer, var_taskguardcounter As Integer) As Integer
IterationAccomplishedTasksf = m_IterationAccomplishedTasks(var_guardcounter, var_taskguardcounter)
End Function
Property Get OriginXPositionNextL1(var_guardcounter3 As Integer) As Single
OriginXPositionNextL1 = m_OriginXPositionNextL1(var_guardcounter3)
End Property
Public Function OriginXPositionNextfL1(var_guardcounter3 As Integer) As Single
OriginXPositionNextfL1 = m_OriginXPositionNextL1(var_guardcounter3)
End Function
Property Get OriginYPositionNextL1(var_guardcounter4 As Integer) As Single
OriginYPositionNextL1 = m_OriginYPositionNextL1(var_guardcounter4)
End Property
Public Function OriginYPositionNextfL1(var_guardcounter4 As Integer) As Single
OriginYPositionNextfL1 = m_OriginYPositionNextL1(var_guardcounter4)
End Function
Property Get EmergencyVerifierNextL1(var_guardcounter5 As Integer) As Boolean
EmergencyVerifierNextL1 = m_EmergencyVerifierNextL1(var_guardcounter5)
End Property
Public Function EmergencyVerifierNextfL1(var_guardcounter5 As Integer) As Boolean
EmergencyVerifierNextfL1 = m_EmergencyVerifierNextL1(var_guardcounter5)
End Function
Property Get StartingTaskNextL1(var_guardcounter6 As Integer) As Single
StartingTaskNextL1 = m_StartingTaskNextL1(var_guardcounter6)
End Property
Public Function StartingTaskNextfL1(var_guardcounter6 As Integer) As Single
StartingTaskNextfL1 = m_StartingTaskNextL1(var_guardcounter6)
End Function
Property Get SimulationXPositionNextL1(var_guardcounter7 As Integer) As Single
SimulationXPositionNextL1 = m_SimulationXPositionNextL1(var_guardcounter7)
End Property
Public Function SimulationXPositionNextfL1(var_guardcounter7 As Integer) As Single
SimulationXPositionNextfL1 = m_SimulationXPositionNextL1(var_guardcounter7)
End Function
Property Get SimulationYPositionNextL1(var_guardcounter8 As Integer) As Single
SimulationYPositionNextL1 = m_SimulationYPositionNextL1(var_guardcounter8)
End Property
Public Function SimulationYPositionNextfL1(var_guardcounter8 As Integer) As Single
SimulationYPositionNextfL1 = m_SimulationYPositionNextL1(var_guardcounter8)
End Function
Property Get LiberationTimeNextL1(var_guardcounter9 As Integer) As Single
LiberationTimeNextL1 = m_LiberationTimeNextL1(var_guardcounter9)
End Property
Public Function LiberationTimeNextfL1(var_guardcounter9 As Integer) As Single
LiberationTimeNextfL1 = m_LiberationTimeNextL1(var_guardcounter9)
End Function
Property Get CollectedTopScore() As Single
CollectedTopScore = m_CollectedTopScore
End Property
Property Get CollectedTopScoreNormal() As Single
CollectedTopScoreNormal = m_CollectedTopScoreNormal
End Property

Property Get CollectedAlarmScore() As Single
CollectedAlarmScore = m_CollectedAlarmScore
End Property

Public Sub Class_Initialize()
Dim GuardIdentifier As Integer
Dim step_counter As Integer
Dim site_counter As Integer

'set TOP and Coverage scores to zero
m_TOPScore = 0
m_CoverageScore = 0

ReDim m_CoverageforSite(1 To 1, 1 To MaxSites)
ReDim m_CoverageforTimeStep(1 To 1)
ReDim m_ActualPositionX(1 To 1, 1 To MaxGuards)
ReDim m_ActualPositionY(1 To 1, 1 To MaxGuards)
ReDim m_ActualGuardStatus(1 To 1, 1 To MaxGuards)
ReDim m_IterationAccomplishedTasks(0 To MaxGuards, 0 To 2)
ReDim m_LastTaskCounterL0(0 To MaxGuards)

'Initialize Coverages * check MaxSteps
For step_counter = 1 To 1
    For site_counter = 1 To MaxSites - 1
        m_CoverageforSite(step_counter, site_counter) = 0
    Next site_counter
    m_CoverageforTimeStep(step_counter) = 0
Next step_counter

ReDim m_GuardTemptativePlans(max_concurrentiteration_counter)

ReDim m_OriginXPositionNextL1(MaxGuards)
 
ReDim m_OriginXPositionNextL1(MaxGuards)
ReDim m_OriginYPositionNextL1(MaxGuards)
ReDim m_EmergencyVerifierNextL1(MaxGuards)
ReDim m_StartingTaskNextL1(MaxGuards)
ReDim m_SimulationXPositionNextL1(MaxGuards)
ReDim m_SimulationYPositionNextL1(MaxGuards)
ReDim m_LiberationTimeNextL1(MaxGuards)


'Create new plans for each guard in the iteration
'MsgBox "Initialize Temptative " & temptative_iteration_counter
Set m_GuardTemptativePlans(temptative_iteration_counter) = New Collection
For GuardIdentifier = 1 To MaxGuards
    Set m_GuardTemptativePlan = New CGuardTemptativePlan
    'Storage variables initialized
    m_GuardTemptativePlans(temptative_iteration_counter).Add m_GuardTemptativePlan
    m_OriginXPositionNextL1(GuardIdentifier) = 0
    m_OriginYPositionNextL1(GuardIdentifier) = 0
    m_EmergencyVerifierNextL1(GuardIdentifier) = False
    m_StartingTaskNextL1(GuardIdentifier) = 0
    m_SimulationXPositionNextL1(GuardIdentifier) = 0
    m_SimulationYPositionNextL1(GuardIdentifier) = 0
    m_LiberationTimeNextL1(GuardIdentifier) = 0
    
    
    m_LastTaskCounterL0(GuardIdentifier) = 1
    m_IterationAccomplishedTasks(GuardIdentifier, 0) = 0
    m_IterationAccomplishedTasks(GuardIdentifier, 1) = 0
    m_IterationAccomplishedTasks(GuardIdentifier, 2) = 0
Next GuardIdentifier
    
'New Initializations:

m_CollectedTopScore = 0

    
End Sub

Public Sub ConcurrentProcedure(temptative_iteration_counter As Integer, StartVirtualTimeL1 As Single, AvailableTasksIdL1() As Integer)

'Declare new variables used in this procedure
Dim IDAVTask() As Integer
Dim Availability() As Boolean
Dim LastTask() As Integer
Dim StopTemptativeIteration As Integer
Dim guard_counter As Integer
Dim RRecentSelectedTask As Integer
Dim StopNow As Boolean
Dim j As Integer
Dim k As Integer

    '1. Create Array of possible tasks (to be modified by array)**check-out array
    ReDim IDAVTask(UBound(AvailableTasksIdL1()))
    For i = 1 To UBound(AvailableTasksIdL1())
        IDAVTask(i) = AvailableTasksIdL1(i)
        
    Next i
   
    '2.Initialize positions for adding tasks,what is this?
    'i.e. "Last..."
    ReDim LastTask(MaxGuards + 1)
    
    For guard_counter = 1 To MaxGuards
        LastTask(guard_counter) = 0
    Next guard_counter
    
    '3. Set stopping iteration criteria to false,
    'stop interation ia a variable changed at the level of guards
    StopNow = False
    
    '4. Start Looping Construction of Plans
    Do While StopTemptativeIteration < MaxGuards And StopNow = False
       
        
        'ask each guard to consider each task
        'ask each guard to consider each task (randomly)
        
        Randomize
        guard_counter = Int((Rnd) * MaxGuards) + 1
        
         
         'MsgBox "guard" & guard_counter
         
         'MsgBox "temptative" & temptative_iteration_counter
            'consider tasks, but only if new tasks can be added
            If m_GuardTemptativePlans(temptative_iteration_counter).Item(guard_counter).GuardIterationFeasibility = True Then
                
                'new position for plan starting at one
                LastTask(guard_counter) = LastTask(guard_counter) + 1
                
                'EXECUTE consider task procedure
              Call m_GuardTemptativePlans(temptative_iteration_counter).Item(guard_counter).ConsiderTemptativePlans(StartVirtualTimeL1, IDAVTask())
         
         
                'get Recently SelectedTask
                RRecentSelectedTask = m_GuardTemptativePlans(temptative_iteration_counter).Item(guard_counter).RecentSelectedTask
                'MsgBox "Recent Iteration " & temptative_iteration_counter & "Guard_counter " & guard_counter & "TaskID " & RRecentSelectedTask
                
                'update availability array
                If RRecentSelectedTask <> -1 Then
                    For j = 1 To UBound(IDAVTask)
        
                        If IDAVTask(j) = RRecentSelectedTask Then
        
                            If UBound(IDAVTask) > 1 Then
                                For k = j To UBound(IDAVTask) - 1
                                    IDAVTask(k) = IDAVTask(k + 1)
                                Next k
                                ReDim Preserve IDAVTask(UBound(IDAVTask) - 1)
                
                            Exit For
                            Else
                                
                            End If
        
                        Else
                        End If
        
                    Next j
                Else
                End If
         
            Else
                'Add stop iteration due to guards unable of serving tasks
                StopTemptativeIteration = 1 + StopTemptativeIteration
            End If
            
            
    
            'check-out if no tasks are available
            If m_GuardTemptativePlans(temptative_iteration_counter).Item(guard_counter).StopIteration = True Then
                StopNow = True
                'MsgBox "stop!"
                
            Else
            End If
        
    Loop
    'Calculate total TOP Score for the iteration
    
    For guard_counter = 1 To MaxGuards
        m_TOPScore = m_TOPScore + m_GuardTemptativePlans(temptative_iteration_counter).Item(guard_counter).Profit
    Next guard_counter
    
    'print out plan
    Call PrintPlans(temptative_iteration_counter)
    
End Sub

Public Sub CalculateCoverageScore(temptative_iteration_counter As Integer, StartVirtualTimeL1 As Single, _
FinishVirtualTimeL1 As Single, VirtualTimeStepL1 As Single, StandardRadius As Single, EmergencyDuration As Single, AllGuardsID() As Integer)
 
'0. Declarations
Dim RetrieveStatusS() As Variant
Dim XActualCoord() As Single
Dim YActualCoord() As Single
Dim CoverageRadius() As Single
Dim GuardStatus() As String
Dim XCoveredSiteCoordinate As Single
Dim YCoveredSiteCoordinate As Single
Dim Distance() As Single
Dim CoverageMatrix() As Single
Dim WorkloadFraction As Single
Dim NumberofCoverers() As Single
Dim LeftOverVar As Single
Dim guard_counter As Integer
Dim UnavailableTime As Single
Dim Workload As Single
Dim BusyFraction() As Single
Dim BusyFractionM() As Single
Dim OrderedGuardArray() As Single
Dim best_value As Single
Dim best_j As Integer
Dim best_value_guard_ord As Single
Dim RealGuardID As Integer
Dim ord_guard_counter As Integer
Dim site_counter As Integer
Dim StepCounter As Integer
Dim CummulativeWorkLoadFraction As Single
Dim CoverageforSite() As Single
Dim VirtualTime As Single
Dim CummulativeCoverage As Single
Dim i As Integer
Dim j As Integer
Dim CummulativeCoverageforTimeSteps As Single
Dim BusyFractionCoverer() As Single
Dim WasBusy As Single
Dim auxcounter As Integer
Dim coverer As Integer
Dim auxcoverer As Integer
Dim Maxstepsforevent As Integer
Dim GuardTerm() As Single
Dim SiteTerm() As Single
Dim SiteRelFreq() As Single
Dim Denominator As Single
Dim deductcounter As Integer
Dim SurvivalProbability As Single
Dim ProbAlarmDelta As Single
Dim ProbAlarmDeltaSite() As Single
Dim SiteIfCovered() As Single
Dim ProbNoAlarm As Single
Dim CummulativeCoverageSite() As Single
Dim CummulativeCoverageforTimeStep() As Single
Dim LocalDistance As Single
Dim XBaseCoordinate As Single
Dim YBaseCoordinate As Single
Dim ReservedTime As Single

ReDim XActualCoord(1 To MaxGuards)
ReDim YActualCoord(1 To MaxGuards)
ReDim CoverageRadius(1 To MaxGuards)
ReDim CoverageRadius(1 To MaxGuards)
ReDim GuardStatus(1 To MaxGuards)

VirtualTime = StartVirtualTimeL1

StepCounter = 1

'Calculate Maxstepsforevent
Maxstepsforevent = (Int(FinishVirtualTimeL1 - StartVirtualTimeL1) / VirtualTimeStepL1) + 1

ReDim m_SurvivalforTimeStep(1 To Maxstepsforevent + 1)
ReDim m_ActualPositionX(1 To Maxstepsforevent + 1, 1 To MaxGuards)
ReDim m_ActualPositionY(1 To Maxstepsforevent + 1, 1 To MaxGuards)
ReDim m_ActualGuardStatus(1 To Maxstepsforevent + 1, 1 To MaxGuards)
ReDim m_CoverageforSite(1 To Maxstepsforevent + 1, 1 To (MaxSites - 1))
ReDim m_SiteCovered(1 To Maxstepsforevent + 1, 1 To (MaxSites - 1))
ReDim m_CoverageforTimeStep(1 To Maxstepsforevent + 1)
ReDim m_CoverageforTimeStepRaw(1 To Maxstepsforevent + 1)

ReDim CummulativeCoverageforTimeStep(1 To Maxstepsforevent + 1)

CummulativeCoverageforTimeSteps = 0
deductcounter = 0



Do While VirtualTime < FinishVirtualTimeL1
CummulativeCoverage = 0

'MsgBox VirtualTime & " VT"
'1. Retrieve Situation (XActualCoord,YActualCoord,CoverageRadius,Status), obtaining
'values from the array
    
   

    
    For guard_counter = 1 To MaxGuards
        
  
        
        RetrieveStatusS = m_GuardTemptativePlans(temptative_iteration_counter).Item(guard_counter).RetrieveStatus(VirtualTime)
        XActualCoord(guard_counter) = CSng(RetrieveStatusS(0))
        YActualCoord(guard_counter) = CSng(RetrieveStatusS(1))
        CoverageRadius(guard_counter) = CSng(RetrieveStatusS(2))
        GuardStatus(guard_counter) = RetrieveStatusS(3)
        
        m_ActualPositionX(StepCounter, guard_counter) = XActualCoord(guard_counter)
        m_ActualPositionY(StepCounter, guard_counter) = YActualCoord(guard_counter)
        m_ActualGuardStatus(StepCounter, guard_counter) = GuardStatus(guard_counter)
    Next guard_counter
       
    ReDim Distance(1 To MaxGuards) As Single
    ReDim CoverageMatrix(1 To MaxSites - 1, 1 To MaxGuards) As Single
    ReDim NumberofCoverers(1 To MaxSites)
    ReDim SiteRelFreq(1 To MaxSites)
    ReDim ProbAlarmDeltaSite(1 To MaxSites)
    ReDim SiteIfCovered(1 To MaxSites)
    ReDim CummulativeCoverageSite(1 To MaxSites)
    
    SurvivalProbability = Exp(-(MeanRateAlarmsperShift) * (VirtualTime - StartVirtualTimeL1) / TerminationTime)
    
    m_SurvivalforTimeStep(StepCounter) = SurvivalProbability
    
    CummulativeCoverers = 0
    
'2. Construct Matrix of Coverers (Guard,Site)
    For site_counter = 1 To MaxSites - 1
    
        SiteRelFreq(site_counter) = Site(site_counter).RelativeFrequency
        ProbAlarmDeltaSite(site_counter) = 1 - Exp(((-MeanRateAlarmsperShift * SiteRelFreq(site_counter)) * (VirtualTimeStep / TerminationTime)))
        XCoveredSiteCoordinate = Site(site_counter).XCoordinate
        YCoveredSiteCoordinate = Site(site_counter).YCoordinate
        XBaseCoordinate = Site(0).XCoordinate
        YBaseCoordinate = Site(0).YCoordinate
        
        'What if busy?******
        For guard_counter = 1 To MaxGuards
            Distance(guard_counter) = ((XActualCoord(guard_counter) _
            - XCoveredSiteCoordinate) ^ 2 + (YActualCoord(guard_counter) _
            - YCoveredSiteCoordinate) ^ 2) ^ 0.5
        
            LocalDistance = ((XBaseCoordinate _
            - XCoveredSiteCoordinate) ^ 2 + (YBaseCoordinate _
            - YCoveredSiteCoordinate) ^ 2) ^ 0.5
        
        ReservedTime = EmergencyDeterministicDuration - CoverageRadius(guard_counter)
        
        If VirtualTime < TerminationTime - Distance(guard_counter) - ReservedTime - LocalDistance - EmergencyDeterministicDuration Then
        
            If Distance(guard_counter) < CoverageRadius(guard_counter) Then
                
                SiteIfCovered(site_counter) = 1
            Else
                
                SiteIfCovered(site_counter) = 0 + SiteIfCovered(site_counter)
            End If
         Else
            
            SiteIfCovered(site_counter) = 0
         End If
            
            'MsgBox CoverageMatrix(site_counter, guard_counter) & "CovMat" & " S" & site_counter & " G" & guard_counter
            '2.a.Calculate number of covered sites
            NumberofCoverers(site_counter) = NumberofCoverers(site_counter) _
            + CoverageMatrix(site_counter, guard_counter)
        
        Next guard_counter
        
        m_CoverageforSite(StepCounter, site_counter) = SiteIfCovered(site_counter) * ProbAlarmDeltaSite(site_counter) * SurvivalProbability
         
         If SiteIfCovered(site_counter) = 1 Then
            m_SiteCovered(StepCounter, site_counter) = 1
         Else
            m_SiteCovered(StepCounter, site_counter) = 0
         End If
         
         CummulativeCoverers = CummulativeCoverers + SiteIfCovered(site_counter) * SiteRelFreq(site_counter)
         
        ProbNoAlarm = Exp(-MeanRateAlarmsperShift * (VirtualTime - StartVirtualTimeL1))
        
        CummulativeCoverageSite(site_counter) = m_CoverageforSite(StepCounter, site_counter) + CummulativeCoverageSite(site_counter)
        
        CummulativeCoverageforTimeStep(StepCounter) = m_CoverageforSite(StepCounter, site_counter) + CummulativeCoverageforTimeStep(StepCounter)
        
    Next site_counter
    
     m_CoverageforTimeStepRaw(StepCounter) = CummulativeCoverers
    
    m_CoverageforTimeStep(StepCounter) = CummulativeCoverageforTimeStep(StepCounter)
    
    
    
    'ReDim BusyFraction(1 To MaxGuards)
   
    
'3. Calculate Busy Fraction
    'For guard_counter = 1 To MaxGuards
        'WorkloadFraction = 0
        'Workload = 0
        'UnavailableTime = 0
        'CummulativeWorkLoadFraction = 0
        
        'LeftOverVar = 0
        
        'For site_counter = 1 To MaxSites - 1
            'Avoid division by zero
            'If NumberofCoverers(site_counter) = 0 Then
                'WorkloadFraction = 0
                'CummulativeWorkLoadFraction = WorkloadFraction + CummulativeWorkLoadFraction
            'Else
                'SiteRelFreq(site_counter) = Site(site_counter).RelativeFrequency
                'WorkloadFraction = (1 / NumberofCoverers(site_counter)) * CoverageMatrix(site_counter, guard_counter) * (Distance(guard_counter) + EmergencyDuration) * MeanRateAlarmsperShift * SiteRelFreq(site_counter)
                'CummulativeWorkLoadFraction = WorkloadFraction + CummulativeWorkLoadFraction
            'End If
        'Next site_counter
        
        'Workload = CummulativeWorkLoadFraction
        'No longer necessary as fraction is affected in the denominator and numerator equally
        'UnavailableTime = m_GuardTemptativePlans(temptative_iteration_counter).Item(guard_counter).LeftOver
        'mm and what about the actual time NOW!?
        'BusyFraction(guard_counter) = Workload / (TerminationTime - EmergencyDeterministicDuration)
        'MsgBox BusyFraction(guard_counter) & "BusyFraction"
    'Next guard_counter


'ReDim GuardTerm(1 To MaxGuards)
'ReDim BusyFractionM(1 To MaxGuards, 1 To (MaxSites - 1))
'ReDim SiteTerm(1 To MaxSites)


'Calculate MEXCLP Simplified
 ' CummulativeCoverage = 0
  '  For site_counter = 1 To MaxSites - 1
        'SiteRelFreq(site_counter) = Site(site_counter).RelativeFrequency
        'SiteIfCovered(site_counter) = 0
    'For guard_counter = 1 To MaxGuards
        'If CoverageMatrix(site_counter, guard_counter) = 1 Then
            'SiteIfCovered(site_counter) = CoverageMatrix(site_counter, guard_counter)
        'Else
            'SiteIfCovered(site_counter) = 1
        'End If
    'Next guard_counter
        'CoverageforSite = ProbAlarmDelta
    'Next site_counter
    
    
'Calculate MEXCLP
    'CummulativeCoverage = 0
    'For site_counter = 1 To MaxSites - 1
    'SiteRelFreq(site_counter) = Site(site_counter).RelativeFrequency
        'For guard_counter = 1 To MaxGuards
            'If guard_counter = 1 Then
                'verify for modified busy fraction
                'If CoverageMatrix(site_counter, guard_counter) = 0 Then
                 '   BusyFractionM(guard_counter, site_counter) = 1
                'Else
                 '   BusyFractionM(guard_counter, site_counter) = BusyFraction(guard_counter)
                'End If
                'GuardTerm(guard_counter) = BusyFractionM(guard_counter, site_counter)
            'Else
             '   For auxcounter = 2 To guard_counter
                    'verify for modified busy fraction
              '      If CoverageMatrix(site_counter, auxcounter) = 0 Then
               '         BusyFractionM(auxcounter, site_counter) = 1
                '    Else
                 '       BusyFractionM(auxcounter, site_counter) = BusyFraction(guard_counter)
                  '  End If
                   ' GuardTerm(guard_counter) = GuardTerm(guard_counter - 1) * (1 - BusyFractionM(auxcounter, site_counter))
               ' Next auxcounter
            'End If
        'm_CoverageforSite(StepCounter, site_counter) = 1 - GuardTerm(guard_counter)
         'CummulativeCoverage = CummulativeCoverage + m_CoverageforSite(StepCounter, site_counter) * SiteRelFreq(site_counter)
  'Next site_counter
    

  'm_CoverageforTimeStep(StepCounter) = CummulativeCoverage / Denominator
  
            
  'MsgBox m_CoverageforTimeStep(StepCounter) & "CumCov"

VirtualTime = VirtualTime + VirtualTimeStepL1





CummulativeCoverageforTimeSteps = m_CoverageforTimeStep(StepCounter) + CummulativeCoverageforTimeSteps

StepCounter = StepCounter + 1

Loop

'Consolidate-calculate TAMEXCLP
If StepCounter = 1 Then
    m_CoverageScore = 0
Else
    m_CoverageScore = CummulativeCoverageforTimeSteps
    'MsgBox "CovScore" & m_CoverageScore
End If

'Call PrintPlans(temptative_iteration_counter)

End Sub

Public Sub PrintPlans(temptative_iteration_counter As Integer)
Dim guard_counter As Integer

'For printing plans

For guard_counter = 1 To MaxGuards
    'Titles of Guards
    'MsgBox "Guard " & guard_counter
    'Sequence of tasks
    Call m_GuardTemptativePlans(temptative_iteration_counter).Item(guard_counter).PrintPlan(guard_counter)
Next guard_counter


End Sub

Public Sub PlanStatusVerificationL1(CurrentAlarmTime As Single, selected_iteration_counter As Integer)

'Declarations

Dim guard_counter As Integer
Dim LastTaskCounterL1 As Integer
Dim task_counter As Integer
Dim overall_counter As Integer
Dim CummulativeCoverageforTimeSteps As Single

Dim MaxLastTaskCounterL1 As Integer

'Determines for each plan x/y location of guard and liberation time, collect TOPSCore too
m_CollectedTopScore = 0
overall_counter = 1

guard_counter = 1




MaxLastTaskCounterL1 = 1




For guard_counter = 1 To MaxGuards
    Call m_GuardTemptativePlans(selected_iteration_counter).Item(guard_counter).PlanStatusVerificationL2(CurrentAlarmTime)
    LastTaskCounterL1 = m_GuardTemptativePlans(selected_iteration_counter).Item(guard_counter).LastTaskCounted
    'Set last number of tasks accopmlished by guard in this round
    m_LastTaskCounterL0(guard_counter) = LastTaskCounterL1
    If m_LastTaskCounterL0(guard_counter) > MaxLastTaskCounterL1 Then
        MaxLastTaskCounterL1 = m_LastTaskCounterL0(guard_counter)
    Else
    End If


Next guard_counter

ReDim Preserve m_IterationAccomplishedTasks(MaxGuards, MaxLastTaskCounterL1)

For guard_counter = 1 To MaxGuards
    'Save x/y location, liberation times, origin values for best set of plans of iterations
    m_OriginXPositionNextL1(guard_counter) = m_GuardTemptativePlans(selected_iteration_counter).Item(guard_counter).OriginXPositionNext
    m_OriginYPositionNextL1(guard_counter) = m_GuardTemptativePlans(selected_iteration_counter).Item(guard_counter).OriginYPositionNext
    m_EmergencyVerifierNextL1(guard_counter) = m_GuardTemptativePlans(selected_iteration_counter).Item(guard_counter).EmergencyVerifierNext
    m_StartingTaskNextL1(guard_counter) = m_GuardTemptativePlans(selected_iteration_counter).Item(guard_counter).StartingTaskNext
    m_SimulationXPositionNextL1(guard_counter) = m_GuardTemptativePlans(selected_iteration_counter).Item(guard_counter).SimulationXPositionNext
    m_SimulationYPositionNextL1(guard_counter) = m_GuardTemptativePlans(selected_iteration_counter).Item(guard_counter).SimulationYPositionNext
    m_LiberationTimeNextL1(guard_counter) = m_GuardTemptativePlans(selected_iteration_counter).Item(guard_counter).LiberationTimeNext
        
    
    For task_counter = 2 To m_LastTaskCounterL0(guard_counter)
        m_IterationAccomplishedTasks(guard_counter, task_counter) = m_GuardTemptativePlans(selected_iteration_counter).Item(guard_counter).AccomplishedTasksArrayf(task_counter)
        m_CollectedTopScore = Task(m_IterationAccomplishedTasks(guard_counter, task_counter)).Importance + m_CollectedTopScore
        If Task(m_IterationAccomplishedTasks(guard_counter, task_counter)).TaskType = 1 Then
           m_CollectedAlarmScore = Task(m_IterationAccomplishedTasks(guard_counter, task_counter)).Importance + m_CollectedAlarmScore
        Else
           m_CollectedTopScoreNormal = Task(m_IterationAccomplishedTasks(guard_counter, task_counter)).Importance + m_CollectedTopScoreNormal
        End If
    Next task_counter
Next guard_counter
End Sub
Public Sub InitializeParametersL1(OriginXPositionM() As Single, OriginYPositionM() As Single, EmergencyVerifierM() As Boolean, StartingTaskM() As Single, SimulationXPositionM() As Single, SimulationYPositionM() As Single, LiberationTimeM() As Single)
'setting previous parameters for link between time steps
Dim guard_counter As Integer

For guard_counter = 1 To MaxGuards
    m_GuardTemptativePlans(temptative_iteration_counter).Item(guard_counter).OriginXPositionPrev = OriginXPositionM(guard_counter)
    m_GuardTemptativePlans(temptative_iteration_counter).Item(guard_counter).OriginYPositionPrev = OriginYPositionM(guard_counter)
    m_GuardTemptativePlans(temptative_iteration_counter).Item(guard_counter).EmergencyVerifierPrev = EmergencyVerifierM(guard_counter)
    m_GuardTemptativePlans(temptative_iteration_counter).Item(guard_counter).StartingTaskPrev = StartingTaskM(guard_counter)
    m_GuardTemptativePlans(temptative_iteration_counter).Item(guard_counter).SimulationXPositionPrev = SimulationXPositionM(guard_counter)
    m_GuardTemptativePlans(temptative_iteration_counter).Item(guard_counter).SimulationYPositionPrev = SimulationYPositionM(guard_counter)
    m_GuardTemptativePlans(temptative_iteration_counter).Item(guard_counter).LiberationTimePrev = LiberationTimeM(guard_counter)
Next guard_counter


End Sub


