import React, { createContext, useContext, useEffect, useReducer, useCallback } from "react";
import AsyncStorage from "@react-native-async-storage/async-storage";
import { domains } from "./data";

const STORAGE_KEY = "cyberpath_progress";

export interface ProgressState {
  completedTopicIds: string[];
  bookmarkedTopicIds: string[];
  quizScores: Record<string, number>;
  notes: Record<string, string>;
  diagnosticScores: Record<string, number>;
  scenarioAttempts: { scenarioId: string; actionId: string; score: number; date: string }[];
  lastVisitedTopicId: string | null;
  studySessions: { topicId: string; minutes: number; date: string }[];
  loaded: boolean;
}

const initialState: ProgressState = {
  completedTopicIds: [],
  bookmarkedTopicIds: [],
  quizScores: {},
  notes: {},
  diagnosticScores: {},
  scenarioAttempts: [],
  lastVisitedTopicId: null,
  studySessions: [],
  loaded: false,
};

type Action =
  | { type: "LOAD"; payload: Partial<ProgressState> }
  | { type: "COMPLETE_TOPIC"; topicId: string }
  | { type: "UNCOMPLETE_TOPIC"; topicId: string }
  | { type: "TOGGLE_BOOKMARK"; topicId: string }
  | { type: "SET_QUIZ_SCORE"; topicId: string; score: number }
  | { type: "SET_NOTE"; topicId: string; note: string }
  | { type: "SET_DIAGNOSTIC_SCORES"; scores: Record<string, number> }
  | { type: "ADD_SCENARIO_ATTEMPT"; scenarioId: string; actionId: string; score: number }
  | { type: "SET_LAST_VISITED"; topicId: string }
  | { type: "ADD_STUDY_SESSION"; topicId: string; minutes: number }
  | { type: "IMPORT_DATA"; data: Partial<ProgressState> }
  | { type: "RESET" };

function reducer(state: ProgressState, action: Action): ProgressState {
  switch (action.type) {
    case "LOAD":
      return { ...state, ...action.payload, loaded: true };
    case "COMPLETE_TOPIC":
      if (state.completedTopicIds.includes(action.topicId)) return state;
      return { ...state, completedTopicIds: [...state.completedTopicIds, action.topicId] };
    case "UNCOMPLETE_TOPIC":
      return { ...state, completedTopicIds: state.completedTopicIds.filter((id) => id !== action.topicId) };
    case "TOGGLE_BOOKMARK":
      return {
        ...state,
        bookmarkedTopicIds: state.bookmarkedTopicIds.includes(action.topicId)
          ? state.bookmarkedTopicIds.filter((id) => id !== action.topicId)
          : [...state.bookmarkedTopicIds, action.topicId],
      };
    case "SET_QUIZ_SCORE":
      return { ...state, quizScores: { ...state.quizScores, [action.topicId]: action.score } };
    case "SET_NOTE":
      return { ...state, notes: { ...state.notes, [action.topicId]: action.note } };
    case "SET_DIAGNOSTIC_SCORES":
      return { ...state, diagnosticScores: action.scores };
    case "ADD_SCENARIO_ATTEMPT":
      return {
        ...state,
        scenarioAttempts: [
          ...state.scenarioAttempts,
          { scenarioId: action.scenarioId, actionId: action.actionId, score: action.score, date: new Date().toISOString() },
        ],
      };
    case "SET_LAST_VISITED":
      return { ...state, lastVisitedTopicId: action.topicId };
    case "ADD_STUDY_SESSION":
      return {
        ...state,
        studySessions: [
          ...state.studySessions,
          { topicId: action.topicId, minutes: action.minutes, date: new Date().toISOString() },
        ],
      };
    case "IMPORT_DATA":
      return { ...state, ...action.data };
    case "RESET":
      return { ...initialState, loaded: true };
    default:
      return state;
  }
}

interface ProgressContextType {
  state: ProgressState;
  completeTopic: (topicId: string) => void;
  uncompleteTopic: (topicId: string) => void;
  toggleBookmark: (topicId: string) => void;
  setQuizScore: (topicId: string, score: number) => void;
  setNote: (topicId: string, note: string) => void;
  setDiagnosticScores: (scores: Record<string, number>) => void;
  addScenarioAttempt: (scenarioId: string, actionId: string, score: number) => void;
  setLastVisited: (topicId: string) => void;
  addStudySession: (topicId: string, minutes: number) => void;
  importData: (data: Partial<ProgressState>) => void;
  resetProgress: () => void;
  getExportData: () => string;
  getDomainProgress: (domainId: string) => number;
  getReadinessLabel: (domainId: string) => string;
  getTotalTopics: () => number;
  getRecommendedNext: () => { topicId: string; topicTitle: string; domainTitle: string } | null;
}

const ProgressContext = createContext<ProgressContextType | null>(null);

export function ProgressProvider({ children }: { children: React.ReactNode }) {
  const [state, dispatch] = useReducer(reducer, initialState);

  useEffect(() => {
    AsyncStorage.getItem(STORAGE_KEY).then((data) => {
      if (data) {
        try {
          const parsed = JSON.parse(data);
          dispatch({ type: "LOAD", payload: parsed });
        } catch {
          dispatch({ type: "LOAD", payload: {} });
        }
      } else {
        dispatch({ type: "LOAD", payload: {} });
      }
    });
  }, []);

  useEffect(() => {
    if (state.loaded) {
      const { loaded, ...toSave } = state;
      AsyncStorage.setItem(STORAGE_KEY, JSON.stringify(toSave));
    }
  }, [state]);

  const completeTopic = useCallback((topicId: string) => dispatch({ type: "COMPLETE_TOPIC", topicId }), []);
  const uncompleteTopic = useCallback((topicId: string) => dispatch({ type: "UNCOMPLETE_TOPIC", topicId }), []);
  const toggleBookmark = useCallback((topicId: string) => dispatch({ type: "TOGGLE_BOOKMARK", topicId }), []);
  const setQuizScore = useCallback((topicId: string, score: number) => dispatch({ type: "SET_QUIZ_SCORE", topicId, score }), []);
  const setNote = useCallback((topicId: string, note: string) => dispatch({ type: "SET_NOTE", topicId, note }), []);
  const setDiagnosticScores = useCallback((scores: Record<string, number>) => dispatch({ type: "SET_DIAGNOSTIC_SCORES", scores }), []);
  const addScenarioAttempt = useCallback((scenarioId: string, actionId: string, score: number) => dispatch({ type: "ADD_SCENARIO_ATTEMPT", scenarioId, actionId, score }), []);
  const setLastVisited = useCallback((topicId: string) => dispatch({ type: "SET_LAST_VISITED", topicId }), []);
  const addStudySession = useCallback((topicId: string, minutes: number) => dispatch({ type: "ADD_STUDY_SESSION", topicId, minutes }), []);
  const importData = useCallback((data: Partial<ProgressState>) => dispatch({ type: "IMPORT_DATA", data }), []);
  const resetProgress = useCallback(() => dispatch({ type: "RESET" }), []);

  const getExportData = useCallback(() => {
    const { loaded, ...data } = state;
    return JSON.stringify({ version: 1, exportedAt: new Date().toISOString(), data }, null, 2);
  }, [state]);

  const getDomainProgress = useCallback(
    (domainId: string) => {
      const domain = domains.find((d) => d.id === domainId);
      if (!domain || domain.topics.length === 0) return 0;
      const completed = domain.topics.filter((t) => state.completedTopicIds.includes(t.id)).length;
      return Math.round((completed / domain.topics.length) * 100);
    },
    [state.completedTopicIds]
  );

  const getReadinessLabel = useCallback(
    (domainId: string) => {
      const score = state.diagnosticScores[domainId];
      if (score === undefined) return "Not assessed";
      if (score >= 75) return "Ready";
      if (score >= 45) return "Developing";
      return "Emerging";
    },
    [state.diagnosticScores]
  );

  const getTotalTopics = useCallback(() => {
    return domains.reduce((sum, d) => sum + d.topics.length, 0);
  }, []);

  const getRecommendedNext = useCallback(() => {
    for (const domain of domains) {
      for (const topic of domain.topics) {
        if (!state.completedTopicIds.includes(topic.id)) {
          return { topicId: topic.id, topicTitle: topic.title, domainTitle: domain.title };
        }
      }
    }
    return null;
  }, [state.completedTopicIds]);

  return (
    <ProgressContext.Provider
      value={{
        state,
        completeTopic,
        uncompleteTopic,
        toggleBookmark,
        setQuizScore,
        setNote,
        setDiagnosticScores,
        addScenarioAttempt,
        setLastVisited,
        addStudySession,
        importData,
        resetProgress,
        getExportData,
        getDomainProgress,
        getReadinessLabel,
        getTotalTopics,
        getRecommendedNext,
      }}
    >
      {children}
    </ProgressContext.Provider>
  );
}

export function useProgress() {
  const context = useContext(ProgressContext);
  if (!context) throw new Error("useProgress must be used within ProgressProvider");
  return context;
}
